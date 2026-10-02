--Update Script 2021 V.2
--PATCH 2021 (30)
DROP PROCEDURE  GetRatebyObjectInfo
GO
			DROP PROCEDURE GetRateLoadingByObjectInfo
			GO
			DROP FUNCTION fn_RateCon
			GO
			DROP Function Get_RateLoading
			GO
			DROP Procedure QScheme_Verify_3 
			GO
			DROP Procedure QScheme_Verify_6
			GO

			CREATE PROCEDURE  GetRatebyObjectInfo(  
@P_Code as varchar(20),
@P_TSI as Float,  
@P_SDate as smalldatetime,   
@P_EDate as smalldatetime,  
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
)       
as   

Declare @SPeriod Int

Declare @ExclusiveF as Bit
Declare @PPeriod as Integer
Declare @Prorata as integer
Declare @STime as varchar(5)
Declare @ETime as varchar(5)
Declare @PTerm as integer
Declare @RateLoadingF as bit

Select @PPeriod=0

Select @PPeriod=0

Select 
@ExclusiveF=coalesce(TOC.ExclusiveF,0), 
@prorata=coalesce(TOC.prorata,0), 
@STime=coalesce(TOC.DefSTime,''), 
@ETime=coalesce(TOC.DefETime,''),
@PTerm=coalesce(TOC.PTERM,0),
@SPeriod=coalesce(T.SPeriod,0),
@RateLoadingF=coalesce(T.RateLoadingF,0)
from RateTab T Left Join TOC on (TOC.TOC=T.TOC) 
Where T.Code=@P_Code

if @PTerm=0 
	Select @PTerm=12

if @prorata=0
	Select @Prorata=datediff(day,@P_SDate, dateadd(month,@PTerm,@P_SDate))

if @STime=''
	Select @Stime='12:00'

if @ETime=''
	Select @Stime='12:00'

Select Top 1 *
From
(
SELECT Top 1 @P_Code as Code, cast(0 as Bit) as ProgressiveF, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, @RateLoadingF as RateLoadingF,       
Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
--Rate Always in Percent       
Case       
When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
When RateCon.Unit='M' then RateCon.Rate/10       
else RateCon.Rate end as Rate,       
RateCon.MinTSI as MinTSI,
RateCon.MaxTSI as MaxTSI     
From RateCon
WHERE RateCon.Code=@P_Code  
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And RateCon.ALLOWEDF=1
And RateCon.ProgressiveF=0
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by       
RateCon.AllowedF Desc,       
len(coalesce(RateCon.ValueID1,'')) Desc,       
len(coalesce(RateCon.ValueID2,'')) Desc,       
len(coalesce(RateCon.ValueID3,'')) Desc,       
len(coalesce(RateCon.ValueID4,'')) Desc,       
len(coalesce(RateCon.ValueID5,'')) Desc,       
len(coalesce(RateCon.ValueID6,'')) Desc,       
len(coalesce(RateCon.ValueID7,'')) Desc,       
len(coalesce(RateCon.ValueID8,'')) Desc,       
len(coalesce(RateCon.ValueID9,'')) Desc,       
len(coalesce(RateCon.ValueID10,'')) Desc,       
len(coalesce(RateCon.ValueID11,'')) Desc,       
len(coalesce(RateCon.ValueID12,'')) Desc,       
len(coalesce(RateCon.ValueID13,'')) Desc,       
len(coalesce(RateCon.ValueID14,'')) Desc,       
len(coalesce(RateCon.ValueID15,'')) Desc       

Union All

SELECT @P_Code as Code, 
cast(1 as Bit) as ProgressiveF,
Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
Max(RateCon.PML) as PML, 
Max(RateCon.TExcess) as TExcess, 
@RateLoadingF as RateLoadingF,       
Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
--Rate Always in Percent       
sum(
Case       
When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
When RateCon.Unit='M' then 
Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
)as Rate,
Min(RateCon.MinTSI) as MinTSI,
Max(RateCon.MaxTSI) as MaxTSI     
From RateCon
WHERE RateCon.Code=@P_Code  
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
And RateCon.ALLOWEDF=1
And RateCon.ProgressiveF=1
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )   
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)         

) R


GO


GO
CREATE PROCEDURE GetRateLoadingByObjectInfo(
@P_TSI as Float, 
@P_SDate as smalldatetime, 
@P_EDate as smalldatetime,
@P_TOPRO as varchar(10), 
@P_Code as varchar(20), 
@P_PHolder as varchar(10), 
@P_RegID as varchar(10), 
@P_FLDID as varchar(255),
@P_VALUEID as varchar(255),
@P_VALUEID1 as varchar(15),  
@P_VALUEID2 as varchar(15),  
@P_VALUEID3 as varchar(15),  
@P_VALUEID4 as varchar(15),  
@P_VALUEID5 as varchar(15),  
@P_VALUEID6 as varchar(15),  
@P_VALUEID7 as varchar(15),  
@P_VALUEID8 as varchar(15),  
@P_VALUEID9 as varchar(15),  
@P_VALUEID10 as varchar(15),  
@P_VALUEID11 as varchar(15),  
@P_VALUEID12 as varchar(15),  
@P_VALUEID13 as varchar(15),  
@P_VALUEID14 as varchar(15),  
@P_VALUEID15 as varchar(15)  
) 
AS        
  
Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)

Declare @P_PDate as smalldatetime

Select @P_PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''

Declare @CheckRateConSIBy int
Declare @SPeriod Int

Declare @ExclusiveF as Bit
Declare @PPeriod as Integer
Declare @Prorata as integer
Declare @STime as varchar(5)
Declare @ETime as varchar(5)
Declare @PTerm as integer

Select @PPeriod=0

Select 
@CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0),
@ExclusiveF=TOC.ExclusiveF, 
@prorata=TOC.prorata, 
@STime=TOC.DefSTime, 
@ETime=TOC.DefETime,
@PTerm=TOC.PTERM 
from TOPRO T, TOC Where TOC.TOC=T.TOC and T.TOPRO=@P_TOPRO

if @PTerm=0 
	Select @PTerm=12

if @prorata=0
	Select @Prorata=datediff(day,@P_SDate, dateadd(month,@PTerm,@P_SDate))

if @STime=''
	Select @Stime='12:00'

if @ETime=''
	Select @Stime='12:00'

select @SPeriod=coalesce(R.SPeriod,0) From RateTab R Where R.Code=@P_Code

Select @P_TSI=@P_TSI+case 
When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@P_TOPRO,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@P_PHolder,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@P_RegID, @P_FLDID, @P_VALUEID,-1)
When @CheckRateConSIBy=4 Then dbo.fn_GetTotalSumInsuredByProductAndPHolder(@P_PDate,@P_TOPRO, @P_PHolder, -1)
When @CheckRateConSIBy=5 Then dbo.fn_GetTotalSumInsuredByProductAndInsured(@P_PDate,@P_TOPRO, @P_PHolder, -1)	

else 0
end

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M1 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M2 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )  
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading,@Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M3 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 ) 
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,     
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M4 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                        
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M5 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M6 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID
From RateCon_M7 RateCon 
WHERE RateCon.Code=@P_Code and RateCon.AllowedF=1      
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@P_EDate) else @P_EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @P_SDate, @P_EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, @P_EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )      
And (coalesce(RateCon.ValueID1,'')='' or @P_VALUEID1 =RateCon.ValueID1)       
And (coalesce(RateCon.ValueID2,'')='' or @P_VALUEID2 =RateCon.ValueID2)       
And (coalesce(RateCon.ValueID3,'')='' or @P_VALUEID3 =RateCon.ValueID3)       
And (coalesce(RateCon.ValueID4,'')='' or @P_VALUEID4 =RateCon.ValueID4)       
And (coalesce(RateCon.ValueID5,'')='' or @P_VALUEID5 =RateCon.ValueID5)       
And (coalesce(RateCon.ValueID6,'')='' or @P_VALUEID6 =RateCon.ValueID6)       
And (coalesce(RateCon.ValueID7,'')='' or @P_VALUEID7 =RateCon.ValueID7)       
And (coalesce(RateCon.ValueID8,'')='' or @P_VALUEID8 =RateCon.ValueID8)       
And (coalesce(RateCon.ValueID9,'')='' or @P_VALUEID9 =RateCon.ValueID9)       
And (coalesce(RateCon.ValueID10,'')='' or @P_VALUEID10 =RateCon.ValueID10)       
And (coalesce(RateCon.ValueID11,'')='' or @P_VALUEID11 =RateCon.ValueID11)       
And (coalesce(RateCon.ValueID12,'')='' or @P_VALUEID12 =RateCon.ValueID12)       
And (coalesce(RateCon.ValueID13,'')='' or @P_VALUEID13 =RateCon.ValueID13)       
And (coalesce(RateCon.ValueID14,'')='' or @P_VALUEID14 =RateCon.ValueID14)       
And (coalesce(RateCon.ValueID15,'')='' or @P_VALUEID15 =RateCon.ValueID15)       
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
Select @Temp_Loading=1

Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
Select @HoldF=@Temp_HoldF
Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
Select @Temp_CID=''

if @Temp_CID<>''
Begin
Select @CID=@CID+'|'+@Temp_CID
End

Select @Loading as Loading, @HoldF as HoldF, @HoldMessage as HoldMessage, @CID as CID

GO


GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float, @P_SDate as smalldatetime)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, RateCon.AllowedF, 
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MinRate 
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End /(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		End
	End as MinRate,
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MaxRate
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		End
	End as MaxRate,
	RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI,
	RateCon.PCalc     
	From Acceptance       
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)>=RateCon.MinPeriod)
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, @P_SDate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)     
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT 
	cast(1 as Bit) as ProgressiveF,
	RateTab.Code, 
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                  
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, @P_SDate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @P_SDate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
)       

GO


GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512), CID varchar(512), AggregateTSI Float, SRate Float)   
AS     
BEGIN       
Declare @SPeriod Int
Declare @SDate smalldatetime
Declare @EDate smalldatetime
Declare @TOPRO varchar(10)
Declare @PHolder varchar(10)
Declare @AID varchar(10)
Declare @CheckRateConSIBy int
Declare @OANO Int
Declare @REGID varchar(10)
Declare @FLDID varchar(255)
Declare @VALUEID varchar(255)
Declare @AgeMethod Int


Declare @RateTab Table (
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)
Declare @SRate as Float
Declare @Prorata as int
Declare @PPeriod as int
Declare @ExclusiveF as bit
Declare @STime as varchar(10)
Declare @ETime as varchar(10)

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''
Select @SRate=0


Select @AgeMethod=TOC.AgeMethod, @OANO=A.OANO, @RegID=A.RegID, @FLDID=A.FLDID, @ValueID=A.ValueID, @PHolder=C.PHolder, @AID=A.AID, @SDate=@P_PDate, @EDate=A.EDate, @TOPRO=A.TOPRO, @CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0), @SPeriod=RateTab.SPeriod, @Prorata=C.PRORATA, @PPERIOD=C.PPERIOD, @ExclusiveF=A.EXCLUSIVEF, @STime=A.STime, @ETime=A.ETime
from Acceptance A 
Inner Join Cover C on (C.CNO=A.CNO) 
Inner Join TOC on (TOC.TOC=A.TOC) 
Left Join TOPRO T on (T.TOPRO=A.TOPRO)
Inner join RateTab on (RateTab.Code=@P_Code)
Where A.ANO=@P_ANO 

Select @P_TSI=@P_TSI+case 
	When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@TOPRO,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@PHolder,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=4 Then dbo.fn_GetTotalSumInsuredByProductAndPHolder(@P_PDate,@TOPRO, @PHolder, @OANO)
	When @CheckRateConSIBy=5 Then dbo.fn_GetTotalSumInsuredByProductAndInsured(@P_PDate,@TOPRO, @AID, @OANO)	
	else 0
	end

insert into @RateTab
SELECT Top 1 
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID1 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H1.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc1) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID2 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H2.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc2) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID3 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H3.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc3) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID4 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H4.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc4) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID5 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H5.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc5) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID6 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H6.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc6) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID7 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H7.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc7) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID8 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H8.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc8) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID9 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H9.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc9) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID10 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H10.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc10) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID11 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H11.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc11) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID12 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H12.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc12) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID13 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H13.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc13) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID14 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H14.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc14) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID15 and G.AllowedF=1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H15.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc15) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID15
From AINFO
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (H1.FLDTAB=1 and G1.FLDID=AInfo.FLDID1 and G1.ValueID=AInfo.ValueID1)
 Left Join GenDTab G2 on (H2.FLDTAB=1 and G2.FLDID=AInfo.FLDID2 and G2.ValueID=AInfo.ValueID2)
 Left Join GenDTab G3 on (H3.FLDTAB=1 and G3.FLDID=AInfo.FLDID3 and G3.ValueID=AInfo.ValueID3)
 Left Join GenDTab G4 on (H4.FLDTAB=1 and G4.FLDID=AInfo.FLDID4 and G4.ValueID=AInfo.ValueID4)
 Left Join GenDTab G5 on (H5.FLDTAB=1 and G5.FLDID=AInfo.FLDID5 and G5.ValueID=AInfo.ValueID5)
 Left Join GenDTab G6 on (H6.FLDTAB=1 and G6.FLDID=AInfo.FLDID6 and G6.ValueID=AInfo.ValueID6)
 Left Join GenDTab G7 on (H7.FLDTAB=1 and G7.FLDID=AInfo.FLDID7 and G7.ValueID=AInfo.ValueID7)
 Left Join GenDTab G8 on (H8.FLDTAB=1 and G8.FLDID=AInfo.FLDID8 and G8.ValueID=AInfo.ValueID8)
 Left Join GenDTab G9 on (H9.FLDTAB=1 and G9.FLDID=AInfo.FLDID9 and G9.ValueID=AInfo.ValueID9)
 Left Join GenDTab G10 on (H10.FLDTAB=1 and G10.FLDID=AInfo.FLDID10 and G10.ValueID=AInfo.ValueID10)
 Left Join GenDTab G11 on (H11.FLDTAB=1 and G11.FLDID=AInfo.FLDID11 and G11.ValueID=AInfo.ValueID11)
 Left Join GenDTab G12 on (H12.FLDTAB=1 and G12.FLDID=AInfo.FLDID12 and G12.ValueID=AInfo.ValueID12)
 Left Join GenDTab G13 on (H13.FLDTAB=1 and G13.FLDID=AInfo.FLDID13 and G13.ValueID=AInfo.ValueID13)
 Left Join GenDTab G14 on (H14.FLDTAB=1 and G14.FLDID=AInfo.FLDID14 and G14.ValueID=AInfo.ValueID14)
 Left Join GenDTab G15 on (H15.FLDTAB=1 and G15.FLDID=AInfo.FLDID15 and G15.ValueID=AInfo.ValueID15)
WHERE AINFO.ANO=@P_ANO                       

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)
Declare @Temp_SRate as Float

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)             
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)   
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,      
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)             
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                        
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,            
len(coalesce(RateCon.ValueID15,'')) Desc      

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)      
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                        
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)              
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                    
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                   
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod in (0,1,2) Then 2 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)           
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,     
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,    
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

insert into @RateCon Select @Loading, @HoldF,@HoldMessage,@CID, @P_TSI, @SRate
Return
END  

GO

GO
CREATE Procedure QScheme_Verify_3 
@P_Coverage as varchar(255), 
@P_Code as varchar(10), 
@p_LMonth as float, 
@p_UMonth as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255), 
@P_TSI as float=0 
as 

 
Declare @p_ClassNo int 
Declare @P_SIInceptionF Bit 
Select Top 1 @p_ClassNo=S.ClassNo , @P_SIInceptionF=sM.SIInceptionF 
from 
Scheme_Class S
Inner join Scheme_Master sM on (sM.SchemeNo=S.SchemeNo)
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc 

Select 
S1.Lower, 
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF, 
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF, 
Cast(Max(cast(Coalesce(SI1.HoldF, S1.HoldF) as Int)) as Bit) as HoldF, 
Max(S1.Upper)as Upper, 
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss, 
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition, 
Max(coalesce(SI1.Discount, S1.Discount)) as Discount, 
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower, 
Max(coalesce(SI1.Rate,S1.Rate)) as Rate 
From 
Scheme_Indemnity S1 
Left Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper)
Where 
-- Range by TSI Compare to Header Only Percentage Of Loss
(coalesce(SI1.ClassNo,'')='' or ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end<=SI1.MaxTSI or SI1.MaxTSI=0)))
and S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
and S1.ProgressiveF=0

Group By S1.Lower
 
Union All

Select 
S1.Lower, 
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF, 
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF, 
Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF, 
Max(S1.Upper)as Upper, 
Max(S1.PCTLoss) as PCTLoss, 
Max(S1.PAddition) as PAddition, 
Max(S1.Discount) as Discount, 
sum(
	Case       
	When S3.Unit='F' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end
	When S3.Unit='M' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.RateLower/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)
	else 
	    Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) 
	end 
	) as RateLower,
sum(
	Case       
	When S3.Unit='F' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end
	When S3.Unit='M' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.Rate/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)
	else 
	    Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) 
	end 
	) as Rate
From 
Scheme_Indemnity S1 
Inner Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper 
-- Range by TSI Compare to Header Only Percentage Of Loss
and ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) Between SI1.MinTSI and SI1.MaxTSI or (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI)) 
Inner Join Scheme_Coverage S3 on (S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code)
Where 
S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
and S1.ProgressiveF=1 and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0
Group By S1.Lower
Order By Lower
 
GO

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

GO
--24 MAY 2021 : PENAMBAHAN DEPOSIT FACULTATIVE CESSION
DROP Procedure QDEPOSIT_FACULTATIVE_CESSION 
GO
CREATE Procedure QDEPOSIT_FACULTATIVE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT FPart.ID, RArrDet.RType, FPart.SlipNo, RArrDet.Share, FPart.Comm
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.RType=@P_RType and RArrDet.Status='R')      
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)
WHERE ACCEPTANCE.ANO=@P_ANO

GO

DROP Procedure QREINSURANCE_DEPOSIT
GO
CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.Currency,
AccAss.ID, 
AccAss.Type as Type,
AccAss.RefNo as RefNo, 
sum(-AccAss.Amount) as Total_Deposit, 
Max(coalesce(RPart.Comm, FPart.Comm)) as Comm 
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Left Join RPart on (Accass.Type in ('QS','QP') and RPart.DocNo=AccAss.RefNo and RPart.ID=AccAss.ID)
Left Join Reinsurance on (Reinsurance.RNO=RPart.RNO)
Left Join FPart on (AccAss.Type in ('FO') and FPart.ANO=AccAss.ANO and FPart.SlipNo=AccAss.RefNo and FPart.ID=AccAss.ID)
Left Join RArrDet on (RArrDet.ANO=FPart.ANO and RArrDet.FID=FPArt.FID)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('QS','QP','FO')
Group by AccAss.Currency, AccAss.ID, AccAss.Type, AccAss.RefNo


GO

DROP Procedure QREINSURANCE_DEPOSIT_USAGE
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10), @P_Currency varchar(10)='', @P_Type varchar(10)='', @P_RefNo varchar(50)='')                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and (@P_Currency='' or AccAss.Currency=@P_Currency) 
and (@P_Type='' or AccAss.Type=@P_Type) 
and (@P_RefNo='' or AccAss.RefNo=@P_RefNo)
Group by AccAss.Currency 
having round(sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end),2)<>0 or round(sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end),2)<>0



GO

--25 MAY 2021 : PENAMBAHAN SEGMENT PADA INWARD TREATY
DROP Procedure QInwardTreaty_Data
GO
CREATE Procedure QInwardTreaty_Data(@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.Segment, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO    
GO

--25 MAY 2021 (1) : PENAMBAHAN VTYPE LIMIT PADA USER
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LimitIn' AND Object_ID = Object_ID(N'SysUserVType'))
BEGIN
ALTER TABLE SysUserVType ADD
	LimitIn float(53) NULL
	DECLARE @v sql_variant 
SET @v = N'Max. Limit Amount In'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserVType', N'COLUMN', N'LimitIn'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LimitOut' AND Object_ID = Object_ID(N'SysUserVType'))
BEGIN
ALTER TABLE SysUserVType ADD
	LimitOut float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max. Limit Amount Out'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserVType', N'COLUMN', N'LimitOut'
END
GO



GO
DROP Function GetApprovalLimitFA
GO
CREATE Function GetApprovalLimitFA(@UserID varchar(50), @VType varchar(10), @InOut varchar(10))
RETURNS Float AS        
BEGIN      
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	select 
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @VType<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserVType 
		Where ID=@UserID and VType=@VType
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn
	else
		Select @ApprovalLimit=@LimitOut

	return @ApprovalLimit
END        
GO


-- Patch 2021 (33)
DROP procedure qPolicyData
GO
Create procedure qPolicyData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '  
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND (COVER.CSTATUS<>''C'') AND (Acceptance.pAStatus<>''W'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  
else
 Select @SQL = @SQL + ' Where 1<>1'
Execute (@SQL)  





go

--4 Jun 2021
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_Service_Profile') AND parent_object_id = OBJECT_ID(N'Service'))
begin
Alter Table Service drop constraint FK_Service_Profile
END
go

--8 Jun 2021 : Penambahan Currency yang melink ke ICover
DROP Function FN_Currency
GO
Create Function FN_Currency(@P_ANO as integer)
RETURNS Table 
AS RETURN ( 
Select Currency.Currency, Currency.Description
from Currency 
Inner Join SysTab on (1=1)
Left Join (Select Distinct ANO, Currency from ICover Where ANO=@P_ANO) ICover on (ICover.ANO=@P_ANO)
Where Currency.AllowedF=1 
and ((coalesce(ICover.ANO,0)=0 and Currency.Currency=SysTab.Currency) or Currency.Currency=ICover.Currency)
) 

go

--10 JUN 2021

DROP function fn_GetServicingActionUser
go
CREATE Function fn_GetServicingActionUser(@ActionCode varchar(10), @SNO int)   

RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  

AS   

BEGIN   

 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)

 Declare @Type varchar(10)



 Declare @LOB Varchar(10)

 Declare @BType Varchar(10)

 Declare @SType varchar(10)

 Declare @TOC varchar(10)

 Declare @Branch varchar(10)

 Declare @ISType varchar(1)

 Declare @Amount Float

 Declare @ApprLimitPCT Float



 Select

 @LOB=coalesce(BS.LOB,''), 

 @BType=Case When S.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 

 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,

 @TOC=S.TOC,

 @Branch=S.Branch,

 @ISType=S.ISType,

 @Amount=S.TSI,

 @ApprLimitPCT=100

 from Service S

 Left Join PolicyType PT on (PT.PolicyType=S.PolicyType)

 Left Join Profile BS on (BS.ID=S.BSID) 

 Where S.SNO=@SNO



 insert into @T

 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 

 from

 (

	 Select S.ID, S.Name, S.Type, S.TypeDesc, 

	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit

	 from

	 (

		Select Distinct S.*

		From

		( 

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc

			from ActionUser S1

			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)

			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))

			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)

			Inner Join SysUserType S5 on (S5.Type=S2.Type)

			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)

			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))



			Union All



			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc

			from ActionUser S1

			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)

			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))

			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)

			Inner Join SysUserType S5 on (S5.Type=S2.Type)

			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)

			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

		) S

	 ) S

 ) S

 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)



 Select top 1 @Type=T.Type from @T T

 Order by T.ApprovalLimit



 --insert into @ActionUser 

 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate

 --from @T T

 --Where T.Type=@Type



 insert into @ActionUser 

 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate

 from @T T

 Where T.Type=@Type



Return   

End   
go

-- Patch 2021 (34)
DROP Function Premium_MaxOutGo
GO
CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_VAT(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_HandlingFee(@P_ANO, @P_Code,@P_Period)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      




go

--14 JUN 2021 : PENAMBAHAN CEEDING PADA SERVICING
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CedingID' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE Service ADD
	CedingID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Ceding ID for Indirect Business or Coinsurance Member'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'CedingID'
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CedingShare' AND Object_ID = Object_ID(N'Service'))
BEGIN
ALTER TABLE Service ADD
	CedingShare float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Ceding Share for Indirect Business or Coinsurance Member'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'CedingShare'
END
GO

GO
DROP PROCEDURE QSRACC_1 
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, 
TOC.RegID, TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI, 
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo,
ISource.ID as CedingID, ISource.Share as CedingShare
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join ISource on (ISource.CNO=Acceptance.CNO)

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM','RENEWAL') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 
 
GO

DROP Procedure qServicing_Data
GO
CREATE Procedure qServicing_Data(@P_SNO integer) 
AS 
Select S1.SNO, S1.ServiceNo, S1.ServiceDate, S1.SType, S1.Subject, S1.ServiceInfo, S1.Validation, 
S1.PolicyNo, S1.CertificateNo, S1.RefNo, S1.ClaimNo, S1.TOC, S1.TopRO, S1.CoverDate, S1.ExpDate, S1.PID, S1.Name, S1.Address_1, S1.Address_2, S1.Phone_1, S1.Fax_1,S1.PType,S1.CGroup, S1.Area, S1.AID, S1.Insured, 
S1.MO, S1.Segment, S1.Branch, S1.CT, S1.ISType, S1.PolicyType, S1.Code, S1.Coverage, S1.Currency, S1.TSI, S1.ATSI, S1.Rate, S1.Premium, S1.SStatus, S1.BSID, S1.BSName, S1.BSType, S1.TBAF, 
S1.CedingID, S1.CedingShare, 
S1.UserID, S1.CDate, S1.CTime, 
S1.LUserID, S1.LDate, S1.LTime, 
S1.CUserID, S1.CloseDate, S1.CloseTime, 
S1.PUserID, S1.PUserDate, S1.PUserTime, 
S1.AUserID, S1.AUserDate, S1.AUserTime, 
S1.PANO, S1.ANO, S1.LANO, S1.CNO, S1.PSNO, S1.VSeqNo, S1.Remarks, S1.ASource, S1.RegID, S1.FLDID, S1.ValueID, S1.ValueDesc, S1.InfoF, S1.SurveyF, S1.Priority, S1.RequestF, S1.RequestMessage, S1.RequestName, 
S1.STime, S1.ETime,
S2.FLDID1, S2.VALUEID1, S2.VALUEDESC1, 0 as FLDSEARCH1, 
S2.FLDID2, S2.VALUEID2, S2.VALUEDESC2, 0 as FLDSEARCH2, 
S2.FLDID3, S2.VALUEID3, S2.VALUEDESC3, 0 as FLDSEARCH3, 
S2.FLDID4, S2.VALUEID4, S2.VALUEDESC4, 0 as FLDSEARCH4, 
S2.FLDID5, S2.VALUEID5, S2.VALUEDESC5, 0 as FLDSEARCH5, 
S2.FLDID6, S2.VALUEID6, S2.VALUEDESC6, 0 as FLDSEARCH6, 
S2.FLDID7, S2.VALUEID7, S2.VALUEDESC7, 0 as FLDSEARCH7, 
S2.FLDID8, S2.VALUEID8, S2.VALUEDESC8, 0 as FLDSEARCH8, 
S2.FLDID9, S2.VALUEID9, S2.VALUEDESC9, 0 as FLDSEARCH9, 
S2.FLDID10, S2.VALUEID10, S2.VALUEDESC10, 0 as FLDSEARCH10, 
S2.FLDID11, S2.VALUEID11, S2.VALUEDESC11, 0 as FLDSEARCH11, 
S2.FLDID12, S2.VALUEID12, S2.VALUEDESC12, 0 as FLDSEARCH12, 
S2.FLDID13, S2.VALUEID13, S2.VALUEDESC13, 0 as FLDSEARCH13, 
S2.FLDID14, S2.VALUEID14, S2.VALUEDESC14, 0 as FLDSEARCH14, 
S2.FLDID15, S2.VALUEID15, S2.VALUEDESC15, 0 as FLDSEARCH15 
from Service S1 Left Join SInfo S2 on (S2.SNO=S1.SNO) 
Where S1.SNO=@P_SNO 
 
 

GO


--PATCH 2021 (36)
DROP Function fn_GetPolicyActionUser
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @ApprLimitPCT=fc.ApprLimitPCT
 from Acceptance A 
 Inner Join fn_Approval_Production(@ANO) fC on (1=1)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO
DROP Function fn_GetClaimProcessActionUser
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Estimate
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   
GO

DROP Function fn_GetClaimApprovalActionUser
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 

GO
DROP Function fn_GetClaimApprovalActionUser
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SR_TOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN

Drop function FL_SR_TOC
end
Go

Create function FL_SR_TOC(@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  



RETURNS Table  



AS RETURN  



(







Select Distinct TOC.TOC,TOC.Description, TOC.NOINPUTF ,TOC.DEFSTIME,TOC.DEFETIME



From TOC, PTClass, SysUserTOC S 



Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and (PTCLASS.TOC='<All>' or PTCLASS.TOC=TOC.TOC) and TOC.TOC like @P_TOC+'%' 



and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)



and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)



)




GO

DROP Function fn_GetServicingActionUser
GO
CREATE Function fn_GetServicingActionUser(@ActionCode varchar(10), @SNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When S.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=S.TOC,
 @Branch=S.Branch,
 @ISType=S.ISType,
 @Amount=S.TSI,
 @ApprLimitPCT=100
 from Service S
 Left Join PolicyType PT on (PT.PolicyType=S.PolicyType)
 Left Join Profile BS on (BS.ID=S.BSID) 
 Where S.SNO=@SNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   



GO

--16 JUN 2021 : PENAMBAHAN HINT SAMPAI 30
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_21' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_21 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -21)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_21'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_22' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_22 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -22)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_22'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_23' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_23 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -23)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_23'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_24' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_24 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -24)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_24'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_25' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_25 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -25)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_25'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_26' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_26 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -26)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_26'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_27' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_27 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -27)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_27'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_28' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_28 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -21)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_28'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_29' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_29 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -29)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_29'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNT_30' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	AMOUNT_30 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Portion of Amount (see hint Table -30)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'AMOUNT_30'
END
GO


--25 JUN 2021 : PENAMBAHAN CEEDING
DROP Procedure QInwardTreaty_Data
GO
CREATE Procedure QInwardTreaty_Data(@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.Segment, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.CedingID, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO 

GO


--28 JUN 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ConjunctExcessClaimF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	ConjunctExcessClaimF bit NULL
DECLARE @v sql_variant 
SET @v = N'Include Excess from Claim Conjunction (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'ConjunctExcessClaimF'
END
GO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionRetentionClaim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionRetentionClaim
end
GO
Create Procedure QGetConjunctionRetentionClaim(@P_CNO as integer)
as
Select sum(CArrHeader.RAmount) as Retention
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner Join Claim C2 on (C2.PolicyNo=A2.PolicyNo and C2.CERTIFICATENO=A2.CERTIFICATENO)
Inner Join CArrHeader on (CArrHeader.CNO=C2.CNO)
Inner Join TOC on (TOC.TOC=C2.TOC and TOC.ConjunctExcessClaimF=1)
Where C1.CNO=@P_CNO 
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A') 
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionERetentionClaim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionERetentionClaim
end
GO
Create Procedure QGetConjunctionERetentionClaim(@P_CNO as integer)
as
Select sum(CArrHeader.ERAmount) as ERetention
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner Join Claim C2 on (C2.PolicyNo=A2.PolicyNo and C2.CERTIFICATENO=A2.CERTIFICATENO)
Inner Join CArrHeader on (CArrHeader.CNO=C2.CNO)
Inner Join TOC on (TOC.TOC=C2.TOC and TOC.ConjunctExcessClaimF=1)
Where C1.CNO=@P_CNO 
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A') 
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 


GO


--6 JUL 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ERule' AND Object_ID = Object_ID(N'SysProcID'))
BEGIN
ALTER TABLE SysProcID ADD
	ERule varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'E Mail Rule for CARERPC (Category=''RPC'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysProcID', N'COLUMN', N'ERule'
END
GO

GO


--8 JUL 2021 : CASH CALL CONJUNCT
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CashCallOnEstimateF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	CashCallOnEstimateF bit NULL
DECLARE @v sql_variant 
SET @v = N'Cash Call on Estimate Payment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CashCallOnEstimateF'
END
GO



GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CashCallOnGrossF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	CashCallOnGrossF bit NULL
DECLARE @v sql_variant 
SET @v = N'Cash Call on Gross Claim (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CashCallOnGrossF'
END
GO



GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CASHLOSS' AND Object_ID = Object_ID(N'RPART'))
BEGIN
ALTER TABLE RPART ADD
	CASHLOSS float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Treaty Participant Cash Loss Limit (Default 0 : not applied Refer to Treaty Cash Loss Limit)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPART', N'COLUMN', N'CASHLOSS'
END
GO



GO

DROP PROCEDURE CLVIEW06B 
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE,
pC.TAmount as PrevOurShare, pC.MAmount as PrevMAmount,
pC.CAMOUNT as PREVCAMOUNT, pc.XPAMOUNT as PREVXPAMOUNT, pC.DAmount as PREVDAmount, pC.QAMOUNT as PREVQAMOUNT, pC.SP1AMOUNT as PREVSP1AMOUNT, pC.SP2AMOUNT as PREVSP2AMOUNT, pC.SP3AMOUNT as PREVSP3AMOUNT, pC.AAmount as PREVAAmount, pC.FAmount as PrevFAmount,
pc.XL1AMOUNT as PREVXL1AMOUNT, pc.XL2AMOUNT as PREVXL2AMOUNT, pc.XL3AMOUNT as PREVXL3AMOUNT,pc.XL4AMOUNT as PREVXL4AMOUNT,pc.XL5AMOUNT as PREVXL5AMOUNT,pc.XL6AMOUNT as PREVXL6AMOUNT,pc.XL7AMOUNT as PREVXL7AMOUNT,pC.QXOLAMOUNT as PREVQXOLAMOUNT, pc.RAMOUNT as PREVRAMOUNT,
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
INNER JOIN CARRHEADER C ON (C.CNO=CLAIM.CNO)
INNER JOIN RARRHEADER R ON (R.ANO=ACCEPTANCE.ANO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
LEFT JOIN CARRHEADER pC ON (pC.CNO=CLAIM.pCNO and CLAIM.CSEQNO>0)
WHERE CLAIM.CNO=@P_CNO 

GO

DROP PROCEDURE CLView06a
GO
CREATE PROCEDURE CLView06a (@P_CNO as integer)
AS
SELECT CLAIM.CLAIMNO, CLAIM.ANO, CLAIM.CNO, CLAIM.LOSSDATE, CLAIM.CTYPE,
CCALC.RATE, 
CCALC.SHARE AS PCTSHARE,
CCALC.LOSS AS ESTIMATE,
CCALC.CLAIM AS OURSHARE,
CCALC.EDEDUCTIBLE AS EDEDUCTIBLE,
CCALC.DEDUCTIBLE AS DEDUCTIBLE,
CCALC.COST,
CCALC.RCOST AS RCOST,
CCALC.ECOST,
CCALC.ERCOST AS ERCOST,
CCALC.SALVAGE AS SALVAGE,
CCALC.SUBROGATION As SUBROGATION,
COALESCE(ISOURCE.LIMIT,0) AS LIMIT,
COALESCE(ISOURCE.EXCESS,0) AS EXCESS,
PCCALC.CLAIM as PrevOURSHARE,
PCCALC.DEDUCTIBLE as PrevDEDUCTIBLE,
PCCALC.COST as PrevCost,
PCCALC.SALVAGE AS PrevSALVAGE,
PCCALC.SUBROGATION As PrevSUBROGATION,
TOC.CashCallOnPartialPaymentF, TOC.CashCallOnEstimateF, TOC.CashCallOnGrossF
From CCALC 
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO) 
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0)
WHERE CCALC.CNO=@P_CNO



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetEstimateClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetEstimateClaimForCashCall
end
GO
Create Procedure QGetEstimateClaimForCashCall(@P_CNO as integer)                  
as     
Select sum(CCalc.Rate * ((CCalc.Loss- CCalc.EDeductible - CCalc.Salvage + CCalc.ECost - CCalc.Subrogation)*CCalc.Share/100+CCalc.ERCost)) 
as Estimate
from CCalc 
Where CCALC.CNO=@P_CNO

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionEstimateClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionEstimateClaimForCashCall
end
GO
Create Procedure QGetConjunctionEstimateClaimForCashCall(@P_CNO as integer)
as

Select sum(CCalc.Rate * ((CCalc.Loss- CCalc.EDeductible - CCalc.Salvage + CCalc.ECost - CCalc.Subrogation)*CCalc.Share/100+CCalc.ERCost)) 
as Estimate
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner Join Claim C2 on (C2.PolicyNo=A2.PolicyNo and C2.CERTIFICATENO=A2.CERTIFICATENO)
Inner Join CCalc on (CCALC.CNO=C2.CNO)
Where C1.CNO=@P_CNO 
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A') 
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 

GO

DROP Procedure CLView20
GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, 
@CNO as CNO, C1.*, C1.Estimate*C1.Share/100 as PEStimate, C1.Indemnity*C1.Share/100 as PIndemnity, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.
AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL7ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	CarrHeader.TAmount as GIndemnity, CArrHeader.ETAmount as GEstimate, 
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	100 as Share
	from Acceptance A, Claim C, RArrHeader R, RArrDet R1, FPart R2, CArrheader     
	Where R1.FullCoverF=1 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=A.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	and C.CNO=@CNO

	union all

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	CarrHeader.TAmount as GIndemnity, CArrHeader.ETAmount as GEstimate, 
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	100 as Share
	from Acceptance A, Claim C, COL, RArrHeader R, RArrDet R1, FPart R2, CArrHeader, FPartDet,
	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	GROUP BY C.CNO
	) CCALC
	Where R1.FullCoverF=0 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=C.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND COL.COL=C.COL AND CCALC.CNO=C.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	AND FPartDet.ANO=R1.ANO AND FPartDet.FID=R1.FID AND FPartDet.ID=R2.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)    
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	And C.CNO=@CNO
) C1
Inner Join Profile on (Profile.ID=C1.ID)
Inner join Claim on (Claim.CNO=@CNO)
Inner Join TOC on (TOC.TOC=Claim.TOC)
Left Join Event on (Event.EventNo=Claim.EventNo)
Inner Join (
	Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
	from Docstat D, SysClass S 
	Where D.Purpose='RI' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
	) S on (
		exists (Select Top 1 Document from CLNotify C2 Where C2.CNO=@CNO and C2.Type=C1.Type and C2.RID=C1.RID and C2.ID=C1.ID and S.Document=C2.Document)
		or
		(charindex(Claim.CType, S.ClaimCType)>0 and charindex(Claim.CStatus, S.ClaimCStatus)>0)
	)
Left Join CLNotify C2 on (C2.CNO=@CNO and C2.Type=C1.Type and C2.RID=C1.RID and C2.ID=C1.ID and S.Document=C2.Document)
Where 
(
	(C1.Type in ('FO')) or 
	(C1.Type in ('X1','X2','X3','X4','X5','X6','X7') and coalesce(Event.Category,'')<>'E') or 
	(C1.Type not in ('X1','X2','X3','X4','X5','X6','X7','FO') and ((C1.CLAIMCOOP>0 and C1.Estimate>=C1.ClaimCoop) or (C1.CashCallLimit>0 and ((TOC.CashCallOnEstimateF=0 and (Case When TOC.CashCallOnGrossF=0 Then C1.Indemnity else C1.GIndemnity end)>=C1.CashCallLimit) or (TOC.CashCallOnEstimateF=1 and (Case When TOC.CashCallOnGrossF=0 Then C1.Estimate else C1.GEstimate end)>=C1.CashCallLimit))) or (C1.PLALimit>0 and C1.Estimate>=C1.PLALimit)))
)
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))

GO

DROP Procedure QCLAIMRCESSION
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end 
as Limit,
CASE WHEN RPART.CASHLOSS<>0 THEN RPART.CASHLOSS ELSE REINSURANCE.CASHLOSS END*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSS, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
LEFT JOIN Event ON (Event.EventNo=Claim.EventNo)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO 
		and exists (
			Select Claim.TOC Where Claim.TOC=R.TOC
			
			union all

			Select Distinct C1.TOC 
			from Claim C1
			Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
			Where Claim.EventNo>0 and C1.EventNo=Claim.EventNo and C2.Status='A'and C1.TOC=R.TOC
			and (
				Case 
				When Reinsurance.RType='X1' Then C2.XL1ID
				When Reinsurance.RType='X2' Then C2.XL2ID
				When Reinsurance.RType='X3' Then C2.XL3ID
				When Reinsurance.RType='X4' Then C2.XL4ID
				When Reinsurance.RType='X5' Then C2.XL5ID
				When Reinsurance.RType='X6' Then C2.XL6ID
				When Reinsurance.RType='X7' Then C2.XL7ID
				Else ''
				end)=@P_RID
		)
		Order by Case When coalesce(Event.Category,'')='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=REINSURANCE.RYEAR and ReRate.Currency=REINSURANCE.Currency)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET Inner Join LCALC on (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=CLAIM.ANO AND RCALC.EXTREATYF=1)     
and (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or REINSURANCE.Currency=SysTab.Currency)

GO

DROP PROCEDURE QClaim_1 
GO
CREATE PROCEDURE QClaim_1 (@P_CNO as integer) 
AS 
SELECT 
CLAIM.ClaimNo, 
Claim.TOC,
Claim.ANO, 
Claim.pCNO, 
Claim.OCNO,
Claim.CType, 
Claim.LossDate,
Claim.LossTime,
Claim.Branch,
Claim.ISType, 
Claim.RCNO,
Claim.EventNo,
Claim.CSeqNo, 
Claim.CStatus,
Claim.RefNo, 
Claim.Payment,
Claim.Claimant, 
Claim.PSettledF,
Acceptance.AName, 
Acceptance.policyno, 
Acceptance.certificateno, 
Acceptance.REGNO, 
Acceptance.CNO AS COVERCNO, 
Acceptance.BIZMAPID, 
Acceptance.Source, 
Acceptance.MSCode, 
Cover.MO,
TOC.CashCallOnEstimateF, 
TOC.CashCallOnGrossF
From CLAIM 
Left Join acceptance on (Acceptance.ANO=Claim.ANO) 
Left Join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join TOC on (TOC.TOC=Claim.TOC)
WHERE CLAIM.CNO=@P_CNO 
 
 
 









GO

--14 JUL 2021
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReferralType') AND type in (N'U'))
BEGIN
CREATE TABLE [ReferralType](
	[ReferralType] [varchar](100) NOT NULL,
 CONSTRAINT [I_ReferralType] PRIMARY KEY CLUSTERED 
(
	[ReferralType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

-- Default Values


insert into ReferralType
Select 'N/A'
union all
Select 'BUSINESS'
union all
Select 'RELATIVE'
union all
Select 'FAMILY'
union all
Select 'SPOUSE'
END
GO

SET ANSI_PADDING OFF
GO


--15 JUL 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DeferralF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE Profile ADD
	DeferralF bit NULL
DECLARE @v sql_variant 
SET @v = N'Deferral Profile (0 : No, 1 : Yes); Ex Because Of Incomplete Profile Document Attachment'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'DeferralF'
END
GO



--15 JUL 2021 : PATCH 2021 (38) COVER.TOC UPDATE MENJADI ACCEPTANCE.TOC
DROP Function ICPS_PolicyDeductible
GO
CREATE Function ICPS_PolicyDeductible(@P_ANO as int, @P_Category as varchar(1))     
RETURNS VarChar(512)        
     
AS        
BEGIN        
 Declare @Remarks as varchar(512)        
 Declare @Remark as varchar(512)       
 Declare @Rate  as varchar(512)      
 Declare @Unit as varchar(512)      
          
 Select @Remarks=''        
 DECLARE AccDed_Cursor CURSOR FOR        
    
 Select Distinct Cast(AccDed.Remarks as varchar(512)) as Remark   
 from dbo.AccDed, dbo.Acceptance, dbo.Cover, dbo.RClass     
 Where Cover.CNO=Acceptance.CNO and AccDed.ANO=Acceptance.ANO   
 and RClass.TOC=Acceptance.TOC and RClass.TOR=AccDed.TOR and (RClass.Category=@P_Category or @P_Category='')     
 and Acceptance.ANO=@P_ANO  
  
 OPEN AccDed_Cursor        
 FETCH FROM AccDed_Cursor into @Remark    
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
    if @Remarks=''        
    BEGIN        
  Select @Remarks=@Remark    
    End        
     Else        
    BEGIN        
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,512)        
    End        
    FETCH NEXT FROM AccDed_Cursor into @Remark    
 End        
 Close AccDed_Cursor        
 Deallocate AccDed_Cursor        
 Return (@Remarks)        
End 

GO

DROP Procedure PCALC01_ADJ
GO
CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  A1.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
RCOVER.LOADING*CASE WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN DBO.FN_RATE_LOADING(RCOVER.ANO) ELSE 1 END AS LOADING,
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  ACCEPTANCE A1
INNER JOIN ACCEPTANCE A2 ON (A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C'))
INNER JOIN COVER ON (COVER.CNO=A1.CNO)
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)
INNER JOIN ICOVER ON (ICOVER.ANO=A1.ANO AND ICOVER.ADJUSTABLE=1)
INNER JOIN RCOVER ON (RCOVER.ANO=A2.ANO)
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE)
INNER JOIN RCLASS ON (RCLASS.TOC=A1.TOC AND RCLASS.TOR=RATECOV.TOR)
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND PCLASS.TOI=ICOVER.TOI)
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)
INNER JOIN RCALC ON (RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate)
Where A1.ANO=@P_ANO AND A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   


GO

DROP Procedure QCheckObjectInsured
GO
CREATE Procedure QCheckObjectInsured(@P_ANO as integer) 
as 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Acceptance A2
Inner Join Cover C2 on (C2.CNO=A2.CNO)
Inner Join TOC on (TOC.TOC=A2.TOC)
Inner Join Acceptance A1 on (A1.ANO<>A2.RANO and A1.ANO<>A1.LANO and A1.OANO<>A2.OANO and A1.REGID=A2.REGID and A1.FLDID<>'' and A1.FLDID=A2.FLDID and A1.ValueID=A2.ValueID)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Left Join AInfo A3 On (A3.ANO=A1.ANO)
Where A2.ANO=@P_ANO and A2.ANO<>A2.LANO 
and A2.AType not in ('A','C') 
and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=0 
group By A1.OANO 
 
Union All 
 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Acceptance A2
Inner join TOC on (TOC.TOC=A2.TOC)
Inner Join Cover C2 on (C2.CNO=A2.CNO)
Inner Join Acceptance A1 on (A1.ANO<>A2.RANO and A1.ANO=A1.LANO and A1.OANO<>A2.OANO and A1.TOC=A2.TOC and A1.RefNo=A2.RefNo)
Inner JOin Cover C1 on (C1.CNO=A1.CNO)
Left Join AInfo A3 On (A3.ANO=A1.ANO)
Where A2.ANO=@P_ANO and A2.ANO=A2.LANO 
and A2.AType not in ('A','C') 
and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=1 
group By A1.OANO 

GO

DROP function MList11D
GO
CREATE function MList11D(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as 
varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as AName,   
 Acceptance.CertificateNo,   
 Cover.CNO,   
 Cover.CStatus,   
 Cover.VSeqNo,   
 Acceptance.LANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear  
FROM   
 Acceptance,   
 Cover,   
 RArrHeader,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 Profile  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
  And Cover.PHOLDER=Profile.ID  
 And (Cover.Insured Like @Value1 Or (Cover.Insured is null))   
 And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
 And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
 And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
 And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
 And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
 And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
 And (Cover.CStatus Like @Value8)   
 And (Acceptance.RegNo Like @Value9)   
 And (Profile.Name like @Value10 or Profile.Name is null)  
 and Acceptance.toc like @Value11  
 And (Acceptance.RefNo Like @Value13)   
 And Cover.ISType<>'T'  
)  
  
GO

--20 JUL 2021 : PENAMABAHAN REFNO PADA ICOVER

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefNo' AND Object_ID = Object_ID(N'ICOVER'))
BEGIN
ALTER TABLE ICOVER ADD
	RefNo varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefDate' AND Object_ID = Object_ID(N'ICOVER'))
BEGIN
ALTER TABLE ICOVER ADD
	RefDate smalldatetime NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocNo' AND Object_ID = Object_ID(N'ICOVER'))
BEGIN
ALTER TABLE ICOVER ADD
	DocNo varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocDate' AND Object_ID = Object_ID(N'ICOVER'))
BEGIN
ALTER TABLE ICOVER ADD
		DocDate smalldatetime NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocNo' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	DocNo varchar(50) NULL	
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocDate' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	DocDate smalldatetime NULL
END
GO


GO
DROP PROCEDURE QCLACC01 
GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC, ICOVER.REFNO, ICOVER.REFDATE, ICOVER.DOCNO, ICOVER.DOCDATE
From CLAIM 
Inner Join COL on (COL.COL=Claim.COL)
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Claim.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
Inner Join RCover on (RCover.ANO=Claim.ANO)
Inner Join ICalc on (ICalc.ANO=RCover.ANO and ICalc.Code=RCover.Code and ICalc.SDate=RCover.SDate and (@PINO=0 or ICalc.INO=@PINO) and ICalc.TOR=COL.TOR)
Inner Join ICover on (ICover.INO=ICalc.INO)
Inner join TOI on (TOI.TOI=ICover.TOI)
WHERE CLAIM.CNO=@PCNO 
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.AllowedF=1
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSRACC_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP PROCEDURE QSRACC_1 
end
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, 
TOC.RegID, TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI, 
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo,
Acceptance.STime, Acceptance.ETime,
ISource.ID as CedingID, ISource.Share as CedingShare
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join ISource on (ISource.CNO=Acceptance.CNO)

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM','RENEWAL') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I')
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 
 
 GO


DROP Function FL_CL_TOI
GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC, ICOVER.REFNO, ICOVER.REFDATE, ICOVER.DOCNO, ICOVER.DOCDATE    

From CLAIM 
Inner Join COL on (COL.COL=Claim.COL)
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Claim.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
Inner Join RCover on (RCover.ANO=Claim.ANO)
Inner Join ICalc on (ICalc.ANO=RCover.ANO and ICalc.Code=RCover.Code and ICalc.SDate=RCover.SDate and ICalc.TOR=COL.TOR)
Inner Join ICover on (ICover.INO=ICalc.INO)
Inner join TOI on (TOI.TOI=ICover.TOI)
WHERE CLAIM.CNO=@PCNO 
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.AllowedF=1
)   


GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'INO' AND Object_ID = Object_ID(N'ACCINVOICE'))
BEGIN
ALTER TABLE ACCINVOICE ADD
	INO int NULL
DECLARE @v sql_variant 
SET @v = N'Acceptance ANO'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'ANO'
SET @v = N'Refer to Interest Cover (ICover)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'INO'
END
GO

ALTER TABLE ACCINVOICE ALTER COLUMN INO int NOT NULL
GO
ALTER TABLE ACCINVOICE drop constraint I_ACCINVOICE
GO
ALTER TABLE ACCINVOICE add constraint I_ACCINVOICE Primary Key (ANO,INO)
GO
ALTER TABLE [ACCINVOICE]  WITH NOCHECK ADD  CONSTRAINT [FK_ACCINVOICE_ICOVER] FOREIGN KEY([INO])
REFERENCES [ICOVER] ([INO]) ON UPDATE CASCADE ON DELETE CASCADE
GO

GO

DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   
Delete from PNOTES Where ANO=@P_ANO   
Delete from ICOVERPOL Where ANO=@P_ANO   
Delete from ClaimPaymentSchedule Where ANO=@P_ANO   

GO

DROP PROCEDURE QAccInvoice
GO
CREATE PROCEDURE QAccInvoice(@P_INO as integer)
AS
SELECT *
From AccInvoice
WHERE INO=@P_INO


GO

DROP PROCEDURE View02 
GO
CREATE PROCEDURE View02 (@pANO as integer) 
AS
SELECT Acceptance.ANO, Cover.CoverNo, Acceptance.RegNo, Acceptance.AType, Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.Remarks, 
Acceptance.ADate, Acceptance.PDate, Acceptance.PPDate, Cover.Voyage, Cover.OpenFlag, Acceptance.COMMENT 
FROM Acceptance
Inner join Cover on (Cover.CNO=acceptance.CNO)
WHERE acceptance.ANO=@pANO


GO

DROP PROCEDURE QCLACC01_1
GO
CREATE PROCEDURE QCLACC01_1 (@PCNO AS INTEGER,@PTOI AS NVarchar(10))        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC, ICOVER.REFNO, ICOVER.REFDATE, ICOVER.DOCNO, ICOVER.DOCDATE
From CLAIM 
Inner Join COL on (COL.COL=Claim.COL)
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Claim.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
Inner Join RCover on (RCover.ANO=Claim.ANO)
Inner Join ICalc on (ICalc.ANO=RCover.ANO and ICalc.Code=RCover.Code and ICalc.SDate=RCover.SDate and ICalc.TOR=COL.TOR)
Inner Join ICover on (ICover.INO=ICalc.INO and (@PTOI='' or ICOVER.TOI=@PTOI) )
Inner join TOI on (TOI.TOI=ICover.TOI)
WHERE CLAIM.CNO=@PCNO 
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.AllowedF=1
GO


--22 JUL 2021 : PENAMBAHAN OBJECT REGISTER ASPERDAG
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TERMOFPMTTYPE') AND type in (N'U'))
DROP TABLE TERMOFPMTTYPE
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE TERMOFPMTTYPE(
	TERMOFPMTTYPE [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE TERMOFPMTTYPE SET (LOCK_ESCALATION = DISABLE)
GO

INSERT INTO TERMOFPMTTYPE
SELECT 'SKBDN'
GO
INSERT INTO TERMOFPMTTYPE
SELECT 'LC'
GO
INSERT INTO TERMOFPMTTYPE
SELECT 'DP'
GO
INSERT INTO TERMOFPMTTYPE
SELECT 'DA'
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
ALTER TABLE AINFODET
	DROP COLUMN LastANO
GO

GO

ALTER TABLE AINFODET ALTER COLUMN SeqNo int NOT NULL
GO
ALTER TABLE AINFODET drop constraint I_AINFODET
GO
ALTER TABLE AINFODET add constraint I_AINFODET Primary Key (ANO,FLDID, ValueID, SeqNo)
GO
ALTER TABLE AINFODET drop constraint AINFOAINFODET
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TERMOFPMTTYPE' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	TERMOFPMTTYPE varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Term Of Payment Type (see TERMOFPMTTYPE)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'TERMOFPMTTYPE'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocNo' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	DocNo varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Generated Document Numbering (KLP)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'DocNo'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocDate' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	DocDate smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Generated Document Date (KLP)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'DocDate'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Fee float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Admin Fee'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Fee'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_1' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Fee_1 float(53) NULL	
DECLARE @v sql_variant 
SET @v = N'Other Fee - 1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Fee_1'

END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_2' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Fee_2 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Other Fee - 2'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Fee_2'
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	Status varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'''N'' : Not Approved, ''A'' : Approved, ''C'' : Decline'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Status'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	AUserID varchar(50) NULL
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	AUserDate smalldatetime NULL
	END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserTime' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	AUserTime varchar(8) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserID' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	CUserID varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserDate' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	CUserDate smalldatetime NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserTime' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	CUserTime varchar(8) NULL
	END
GO

ALTER TABLE AINFODET ALTER COLUMN	CUserTime varchar(8) NULL
GO
ALTER TABLE AINFODET ALTER COLUMN	AUserTime varchar(8) NULL
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AdmNo' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	AdmNo int NULL
DECLARE @v sql_variant 
SET @v = N'Posting to Admlink for Admin Fee and Other Fee'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'AdmNo'
END
GO


GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCEAPPROVEOBJECTREGISTER')
BEGIN
insert into sysform (FName, Description, FCode, RequestF) values('FORCEAPPROVEOBJECTREGISTER','FORCE APPROVE OBJECT REGISTER','ACTIVITIES',0)
end
GO

IF NOT EXISTS(SELECT * FROM AutoNum WHERE AutoNum='KLP')
BEGIN
insert into AutoNum(AutoNum, pvalue1, PFormat1, PValue2, PFormat2, PValue3, PFormat3, PValue4, PFormat4, Seqno, ContinueF, Description, AllowedF, Last_Opr, Last_Update)
Select 'KLP' as AutoNum, pvalue1, PFormat1, PValue2, PFormat2, PValue3, PFormat3, PValue4, PFormat4, Seqno, ContinueF, 'KLP Document' as Description, AllowedF, Last_Opr, Last_Update
from AutoNum 
Where AutoNum='POL' and not exists (Select * from AutoNum Where AutoNum='KLP')
end
GO

/****** Object:  Table [AINFODETPIC]    Script Date: 7/23/2021 1:10:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'AINFODETPIC') AND type in (N'U'))
BEGIN
CREATE TABLE [AINFODETPIC](
	[ANO] [int] NOT NULL,
	[FLDID] [varchar](10) NOT NULL,
	[VALUEID] [varchar](15) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [varchar](max) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_Time] [varchar](8) NULL,
 CONSTRAINT [I_AINFODETPIC] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC,
	[FLDID] ASC,
	[VALUEID] ASC,
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ref to Acceptance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'ANO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ref to TOC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'FLDID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ref to TOC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'VALUEID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'ImageID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'FileType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'Title'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINFODETPIC', @level2type=N'COLUMN',@level2name=N'Remark'
END


GO
DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   
Delete from PNOTES Where ANO=@P_ANO   
Delete from ICOVERPOL Where ANO=@P_ANO   
Delete from ClaimPaymentSchedule Where ANO=@P_ANO   
Delete from AinfoDet Where ANO=@P_ANO   
Delete from AinfoDetPIC Where ANO=@P_ANO   

GO

--PATCH 2021 (39)
DROP Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)   
as   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, 
ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime,
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))   
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY, ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime
ORDER BY ACCEPTANCE.ANO


GO

--PATCH 2021 (40)
DROP PROCEDURE QCLACC_4 
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 10 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC, Acceptance.Branch, Cover.IStype
From ACCEPTANCE
Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
WHERE ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND (
(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
 )             
AND 
(
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)        
Order By ACCEPTANCE.ANO Desc   


GO

--PATCH 2021 (41)

DROP FUNCTION FN_PCalc 
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)            
RETURNS Table            
AS RETURN (            
SELECT  Acceptance.ANO,            
 Count(PCalc.Currency) AS NUMCCY,          
 MAX(PCALC.LMFACTOR) AS LMFACTOR,
 MAX(PCALC.RATE) AS RATE,          
 MAX(PCALC.CRATE) AS CRATE,         
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,            
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,            
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,            
 sum(PCalc.OGross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end/dbo.fn_Premium_Calc_Prorata(Acceptance.Sdate, case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.STime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate End,Cover.Prorata, 12,CASE WHEN Cover.PPeriod in (0,1,2) Then 2 ELSE Cover.PPeriod END)) AS OGross,       
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,            
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/            
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,            
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE, 
 MAX(RARRHEADER.MSHARE) as MSHARE
FROM  Acceptance with(NOLOCK)       
INNER JOIN COVER with(NOLOCK) ON (COVER.CNO=ACCEPTANCE.CNO)
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')       
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)      
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)            
Where Acceptance.ANO=@P_ANO            
GROUP BY Acceptance.ANO            
)            

GO

DROP Procedure QPCALC_ACCASS
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end) as SDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, 
ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1 then coalesce(P.InstAmount,0) else coalesce(P.InstPCT,100)/100*(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) end) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)   
Left Join Payor on (Payor.ANO=@P_ANO)
Left Join APayor on (APayor.ANO=@P_ANO)  
Left Join Payor_Schedule P on (P.ANO=@P_ANO and (coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) and P.InstDate Between ICalc.SDate and dateadd(day,-1,ICalc.EDate))
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end),
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end),
(Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     
GO

--PATCH 2021 (42)
DROP PROCEDURE Claim_Cession 
GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255), @pReAllocF as bit=0)                    
AS                    
SELECT Top 1
coalesce(RePolicy.ID,'') as ID, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Limit,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Excess,                    
Reinsurance.RYear,
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 
REINSURANCE.Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Deductible, 
REINSURANCE.Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Aggregate, 
REINSURANCE.A_Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end 
-(
Case 
When @pRType='X1' Then coalesce(pCArr.Xl1Deductible,0)
When @pRType='X2' Then coalesce(pCArr.Xl2Deductible,0)
When @pRType='X3' Then coalesce(pCArr.Xl3Deductible,0)
When @pRType='X4' Then coalesce(pCArr.Xl4Deductible,0)
When @pRType='X5' Then coalesce(pCArr.Xl5Deductible,0)
When @pRType='X6' Then coalesce(pCArr.Xl6Deductible,0)
When @pRType='X7' Then coalesce(pCArr.Xl7Deductible,0)
end
)
as A_Deductible, 
REINSURANCE.A_EDeductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end 
-(
Case 
When @pRType='X1' Then coalesce(pCArr.Xl1EDeductible,0)
When @pRType='X2' Then coalesce(pCArr.Xl2EDeductible,0)
When @pRType='X3' Then coalesce(pCArr.Xl3EDeductible,0)
When @pRType='X4' Then coalesce(pCArr.Xl4EDeductible,0)
When @pRType='X5' Then coalesce(pCArr.Xl5EDeductible,0)
When @pRType='X6' Then coalesce(pCArr.Xl6EDeductible,0)
When @pRType='X7' Then coalesce(pCArr.Xl7EDeductible,0)
end
)
as A_EDeductible, 
REINSURANCE.A_Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end 
-(
Case 
When @pRType='X1' Then coalesce(pCArr.XL1Amount,0)
When @pRType='X2' Then coalesce(pCArr.XL2Amount,0)
When @pRType='X3' Then coalesce(pCArr.XL3Amount,0)
When @pRType='X4' Then coalesce(pCArr.XL4Amount,0)
When @pRType='X5' Then coalesce(pCArr.XL5Amount,0)
When @pRType='X6' Then coalesce(pCArr.XL6Amount,0)
When @pRType='X7' Then coalesce(pCArr.XL7Amount,0)
end
)
as A_Aggregate, 
REINSURANCE.A_EAggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end 
-(
Case 
When @pRType='X1' Then coalesce(pCArr.XL1EAmount,0)
When @pRType='X2' Then coalesce(pCArr.XL2EAmount,0)
When @pRType='X3' Then coalesce(pCArr.XL3EAmount,0)
When @pRType='X4' Then coalesce(pCArr.XL4EAmount,0)
When @pRType='X5' Then coalesce(pCArr.XL5EAmount,0)
When @pRType='X6' Then coalesce(pCArr.XL6EAmount,0)
When @pRType='X7' Then coalesce(pCArr.XL7EAmount,0)
end
)
as A_EAggregate
FROM Claim          
Left Join Event On (Event.EventNo=Claim.EventNo)          
Left Join CarrHeader pCarr on (pCarr.CNO=Claim.pCNO and pCArr.status='A')
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)          
Inner Join Cover on (Cover.CNO=Acceptance.CNO)     
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)     
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO
		and exists (
			Select Claim.TOC Where Claim.TOC=R.TOC

			union All

			Select Distinct C1.TOC 
			from Claim C1
			Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
			Where @pReAllocF=0 and Claim.EventNo>0 and C1.EventNo=Claim.EventNo and C2.Status='A' and C1.TOC=R.TOC
			and Reinsurance.RID=(
				Case 
				When Reinsurance.RType='X1' Then C2.XL1ID
				When Reinsurance.RType='X2' Then C2.XL2ID
				When Reinsurance.RType='X3' Then C2.XL3ID
				When Reinsurance.RType='X4' Then C2.XL4ID
				When Reinsurance.RType='X5' Then C2.XL5ID
				When Reinsurance.RType='X6' Then C2.XL6ID
				When Reinsurance.RType='X7' Then C2.XL7ID
				Else ''
				end)

			union All

			Select Distinct C1.TOC 
			from Claim C1
			Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
			Where @pReAllocF=1 and Claim.EventNo>0 and C1.EventNo=Claim.EventNo and C1.CType<>'C' and C1.CStatus='R' and C1.TOC=R.TOC
			and Reinsurance.RID=(
				Case 
				When Reinsurance.RType='X1' Then C2.XL1ID
				When Reinsurance.RType='X2' Then C2.XL2ID
				When Reinsurance.RType='X3' Then C2.XL3ID
				When Reinsurance.RType='X4' Then C2.XL4ID
				When Reinsurance.RType='X5' Then C2.XL5ID
				When Reinsurance.RType='X6' Then C2.XL6ID
				When Reinsurance.RType='X7' Then C2.XL7ID
				Else ''
				end)
		)
		Order by Case When coalesce(Event.Category,'')='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate R1 on (R1.TOC=Claim.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE Claim.CNO=@PCNO           
and RArrHeader.EXOLF=0        --Not Exclude XOL          
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0)     
and (coalesce(Event.Category,'')<>'E' or ReClass.RiskF=0)     
and (coalesce(Event.Category,'')='E' or Reinsurance.Category<>'E')           
And Reinsurance.Category<>'S' --Not Shortfall Surplus          
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)        
And  
(        
	 ((    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=Cover.Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=PHolder.CGroup))
	 )
)        
-- If Risk is Excluded          
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET INNER JOIN LCALC ON (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.EXCLUDEF=1)          
Order By coalesce(RePolicy.ID,'') Desc, 
(Case When (coalesce(Event.Category,'R')<>'R' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end) Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc

GO

DROP Procedure QCLAIMRCESSION 
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as Limit,
CASE WHEN RPART.CASHLOSS<>0 THEN RPART.CASHLOSS ELSE REINSURANCE.CASHLOSS END*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSS, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
LEFT JOIN Event ON (Event.EventNo=Claim.EventNo)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO 
		and exists (
			Select Claim.TOC Where Claim.TOC=R.TOC
			
			union all

			Select Distinct C1.TOC 
			from Claim C1
			Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
			Where Claim.EventNo>0 and C1.EventNo=Claim.EventNo and C2.Status='A'and C1.TOC=R.TOC
			and (
				Case 
				When Reinsurance.RType='X1' Then C2.XL1ID
				When Reinsurance.RType='X2' Then C2.XL2ID
				When Reinsurance.RType='X3' Then C2.XL3ID
				When Reinsurance.RType='X4' Then C2.XL4ID
				When Reinsurance.RType='X5' Then C2.XL5ID
				When Reinsurance.RType='X6' Then C2.XL6ID
				When Reinsurance.RType='X7' Then C2.XL7ID
				Else ''
				end)=@P_RID
		)
		Order by Case When coalesce(Event.Category,'')='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join ReRate R1 on (R1.TOC=Claim.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET Inner Join LCALC on (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=CLAIM.ANO AND RCALC.EXTREATYF=1)     


GO

DROP Procedure QGet_MinDep 
GO
CREATE Procedure QGet_MinDep (@P_CNO integer, @P_RID varchar(20), @P_PID varchar(10))                                
as    
Select 
Case When Coalesce(RPart.MDP+RPart.AAP,0)<>0 Then Coalesce(RPart.MDP+RPart.AAP,0) Else Reinsurance.MDP+Reinsurance.AAP end*Case When Coalesce(CArrHeader.Limit,0)<>0 Then  Coalesce(CArrHeader.Limit,0) else 1 end*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as MDP, 
Case When Coalesce(RPart.MDP_1+RPart.AAP_1,0)<>0 Then Coalesce(RPart.MDP_1+RPart.AAP_1,0) Else Reinsurance.MDP_1+Reinsurance.AAP_1 end*Case When Coalesce(CArrHeader.Limit,0)<>0 Then  Coalesce(CArrHeader.Limit,0) else 1 end*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as MDP_1 
from Claim
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
LEFT JOIN CARRHEADER ON (CARRHEADER.CNO=CLAIM.CNO)
Inner Join Reinsurance on (Reinsurance.RID=@P_RID)
Inner Join RPart on (RPart.RNO=Reinsurance.RNO and RPart.ID=@P_PID)
Left Join ReRate R1 on (R1.TOC=Claim.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
Where Claim.CNO=@P_CNO 

GO
DROP Procedure QREINSURANCE_CESSION 
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTSI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF,
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and (ReClass.DirectF=0 or Cover.ISType in ('I','L','C')))      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(
	(      
	 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
	 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
	 And (    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=Cover.Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=PHolder.CGroup))
	 )
))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When (@P_ManualF=1 or RArrHeader.ManualF=1) and (Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID) Then 1 Else 0 end Desc, coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc     









GO

--PATCH 2021 (44)
DROP Procedure PCALC02A 
GO
CREATE Procedure PCALC02A (@P_ANO integer,@P_CURRENCY varchar(10))
As

SELECT 
SUM(RCalc.Gross) AS PREMIUM, SUM([RCALC].[OGROSS]) AS OPREMIUM, SUM([RCALC].[DISCOUNT]) AS DISCOUNT, SUM([RCALC].[DDISCOUNT]) AS DDISCOUNT, SUM([RCALC].[LOADING]) AS LOADING
FROM RCALC
WHERE [RCALC].[ANO]=@P_ANO And [RCALC].[CURRENCY]=@P_CURRENCY

GO

--PATCH 2021 (45)
DROP PROCEDURE CLVIEW07L
GO
CREATE PROCEDURE CLVIEW07L(@P_CNO AS INTEGER)  
AS  
SELECT cast(0 as Bit) as ProcessFlag, ClaAss.AdmNo, ClaAss.RefNo, 
Max(ClaAss.BillDate) as BillDate, 
Max(ClaAss.ClaimNo) as ClaimNo, 
ClaAss.ID, 
Max(Profile.Name) as Name, 
ClaAss.Type, 
ClaAss.Currency, 
'CLAIM'=sum(  
CASE  
        WHEN CLAASS.CODE='A' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DEDUCTIBLE'=sum(  
CASE  
        WHEN CLAASS.CODE='E' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'COST'=sum(  
CASE  
        WHEN CLAASS.CODE='L' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SALVAGE'=sum(  
CASE  
        WHEN CLAASS.CODE='S' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SUBROGATION'=sum(  
CASE  
        WHEN CLAASS.CODE='R' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'ADJUSTMENT'=sum(  
CASE  
        WHEN CLAASS.CODE='I' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'PREMIUM'=sum(  
CASE  
        WHEN CLAASS.CODE='P' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'VAT'=sum(  
CASE  
        WHEN CLAASS.CODE='V' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'TAX'=sum(  
CASE  
        WHEN CLAASS.CODE='T' THEN ClaAss.AMOUNT  
        ELSE 0  
END)
+
Max(coalesce(Admlink.Amount_18,0)),  
'FEE'=sum(  
CASE  
        WHEN CLAASS.CODE='F' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DUTY'=sum(  
CASE  
        WHEN CLAASS.CODE='D' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted
FROM ClaAss 
Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE ClaAss.CNO=@P_CNO  
GROUP BY ClaAss.AdmNo, ClaAss.RefNo, ClaAss.ID, ClaAss.Type, ClaAss.Currency

GO

DROP PROCEDURE QCLAASS_3
GO
CREATE PROCEDURE QCLAASS_3(@P_CNO int,@P_RefNo varchar(20), @P_Type varchar(255),@P_ID varchar(255),@P_CCY varchar(255)) 
as 
SELECT  
ClaAss.CNO,
ClaAss.RefNo, 
Max(ClaAss.Date) as Date, 
Max(ClaAss.BillDate) as BillDate, 
ClaAss.TOC, 
Max(ClaAss.DocNo) as DocNo, 
Max(ClaAss.ClaimNo) as ClaimNo, 
Max(ClaAss.Remarks) as Remarks, 
ClaAss.ID, 
Max(Profile.Name) as Name, 
ClaAss.Type, 
ClaAss.Currency,
Max(ClaAss.BizMapID) as BizMapID,
Max(ClaAss.Source) as Source,
Max(ClaAss.MSCode) as MSCode,
Max(ClaAss.RCode) as RCode,
Max(ClaAss.TOR) as TOR,
Max(ClaAss.Currency_OC) as Currency_OC, 
sum(case when ClaAss.code='A' then Amount else 0 end) AS Claim, 
sum(case when ClaAss.code='E' then Amount else 0 end) AS Deductible, 
sum(case when ClaAss.code='L' then Amount else 0 end) AS Cost, 
sum(case when ClaAss.code='S' then Amount else 0 end) AS Salvage, 
sum(case when ClaAss.code='R' then Amount else 0 end) AS Subrogation, 
sum(case when ClaAss.code='P' then Amount else 0 end) AS Premium, 
sum(case when ClaAss.code='I' then Amount else 0 end) AS Adjustment, 
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted
FROM  ClaAss
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE  ClaAss.CNO=@P_CNO 
And ClaAss.RefNo=@P_RefNo 
and ClaAss.Type=@P_Type 
and ClaAss.ID=@P_ID 
and ClaAss.Currency=@P_CCY 
GROUP BY CLAASS.CNO, CLAASS.ID, CLAASS.TOC, CLAASS.Type, CLAASS.Currency, CLAASS.RefNo
 

GO

DROP PROCEDURE QClaAss
GO
CREATE PROCEDURE QClaAss (@PCNO as integer, @PRefNo as varchar(50), @PType as varchar(2), @PCode as varchar(1), @PID as varchar(10), @PCurrency as varchar(10)) 
AS 
SELECT * 
FROM ClaAss 
WHERE ClaAss.CNO=@PCNO And ClaAss.RefNo=@PRefNo and ClaAss.Type=@PType And ClaAss.Code=@PCode And ClaAss.ID=@PID And ClaAss.Currency=@PCurrency 

 

 

 
GO

--PATCH 2021(46) : TUNNING WHTAX
drop index nSL.I_nSL_Doc_No 
GO
create index I_nSL_Voucher_PVoucher on nSL(Voucher, pVoucher)
GO
drop index pVoucher.I_pVoucher_PDate
GO
drop index pVoucher.I_Voucher_DocNo
GO
Create index I_pSL_Voucher_Doc_No_SortNo on pSL(Voucher, Doc_No, SortNo)
GO

drop index pVoucher.I_Voucher_Date
GO
create index I_pVoucher_Date on pVoucher(Date) include(Voucher, SL_Cat, DebtorF, RefNo, Status, Last_Date, Last_Time)
GO
drop index nVoucher.I_Voucher_Branch
GO
Create index I_NVoucher_Branch_TaxF_TaxType on NVoucher(Branch, TaxF, TaxType) include ([Voucher],[Date],[Currency],[Nominal_CC],[Rate],[ProAcc],[DebtorF],[Diff_CC],[Tax_CC],[CT],[TaxPayment_CC])
GO


--PATCH 2021(47)
DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
Declare @MRegNo as varchar(50)
Declare @MSDate as smalldatetime
Declare @MEDate as smalldatetime

Select @MRegNo=RegNo, @MSDate=SDate, @MEDate=EDate from Acceptance Where ANO=@P_ANO

if @MRegNo=''
Begin
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,                 
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC','IR','IT','IX') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,      
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and (Case When Cover.OpenFlag=0 Then PHolder.VATF else Insured.VATF end)=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.TVatF=1 then 0 else 1 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_2, 
	sum(
	Case 	
	When Admlink.Amount is null then
		dbo.Roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance 
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)
	Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.LANO=@P_ANO
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END
ELSE
BEGIN
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,            
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC','IR','IT','IX') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,              
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and (Case When Cover.OpenFlag=0 Then PHolder.VATF else Insured.VATF end)=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.TVatF=1 then 0 else 1 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_2, 
	sum(
	Case 
	When Admlink.Amount is null then
		dbo.roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)
	Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.RegNo=@MRegNo
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END

GO
DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount
  else 0                
 end                
) 
+
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
  else 0                
 end                
) 
-
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Commision,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS OverridingCommission,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then AccAss.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS PremiumAdjustment,                               
sum(                
 case                
  when accass.code='I' then AccAss.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
  when accass.Type Not in ('DI','IC','IR','IT','IX') and accass.code='U' then AccAss.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Advance,                  
dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,        
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and (Case When Cover.OpenFlag=0 Then PHolder.VATF else Insured.VATF end)=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
	)
	,Accass.Currency)
	*(Max(MParam.VAT)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.BVatF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT_1,      
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and PHolder.TVatF=1 then 0 else 1 end)
	)
	,Accass.Currency)
	*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT_2,       
sum(
Case 
When Admlink.Amount is null then
	dbo.roundccy(
	-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
	*(Case When Profile.TaxF=1 Then 1 Else 0 End)
	*(Case 
		When TaxType.MTaxType='PASAL21' Then 
			Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
		When TaxType.MTaxType='PASAL23' Then
			Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
		When TaxType.MTaxType='PASAL26' Then 
			Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
		When TaxType.MTaxType='PASAL4' Then 
			Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
		ELSE Profile.AccruedTax/100
		END)
	*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
	,AccAss.Currency)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as TAX    
FROM Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join Branch on (Branch.Branch=Acceptance.Branch)
Inner Join Profile PHolder on (PHolder.ID=Cover.PHOLDER)
Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
Inner Join Mparam on (MParam.Type=AccAss.Type)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 


GO


--13 AGST 2021 
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'COLLECTIONV'))
BEGIN
ALTER TABLE COLLECTIONV ADD
	Remarks varchar(255) NULL
END
GO



--PATCH 2021 (48)
DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

       Select V.Voucher, 
       cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
       Case 
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC*V.Rate)
       When Max(V.Payment_CC*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
       Else Max(V.Payment_CC*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End*V.Rate
       ) as Nominal_CC
       from Admlink A
	   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency
		and A.Subject='Premium' and A.Type in ('DI','IC','IR')
		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
		and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B
		Inner Join Admlink C on (C.Subject='Premium' and C.Type in ('DI','IC','IR') and C.A_PolicyNo=B.A_PolicyNo and C.DocNo=B.DocNO and C.Date=B.Date)
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
		and B.Subject='Premium' and B.Type=@P_Type 
		order by B.AdmNo Desc
		),'')
       Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End







GO
--PATCH 2021 (49)
DROP function VOUCHER_AMOUNTPERIODDUE
GO
CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,        

(
Case When V.Installment=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case 
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day,A.WPC, V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate then
	(V.Nominal_CC-V.Diff_CC)-V.Payment_CC
else 0
End +
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
	else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end

Else 0
end +

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 
	then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +
  
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate Then   
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end as Outstanding,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
    
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)                  

)      


GO

DROP function VOUCHER_AMOUNTWPCDUE
GO
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day,A.WPC,V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<V.Payment_CC Then 0
else V.AmountDue_1-V.Payment_CC end 
+
Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 

then V.AmountDue_17
else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V Inner Join Admlink A on (A.Voucher=V.Voucher) 
Where (Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0 or V.PDate>=@P_Date) 
) 


GO

DROP function VOUCHER_AMOUNTDUE
GO
CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else V.DueDate
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<V.Payment_CC Then 0
else V.AmountDue_1-V.Payment_CC end 
+
Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 

then V.AmountDue_17
else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V Inner Join Admlink A on (A.Voucher=V.Voucher) 
Where (Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0 or V.PDate>=@P_Date) 
) 




GO
--PATCH 2021 (50)
DROP FUNCTION DISPLAY_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID varchar(20))            
RETURNS TABLE  AS            
RETURN (            
Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,            
D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end            
+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end            
+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation      
from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A 
Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 
) 
GO
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1), SDate Smalldatetime, EDate Smalldatetime)
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod, SDate, EDate FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, ATYPE Varchar(1), FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, ATYPE, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet


if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
		
	from @Acceptance Acceptance
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_ANO 
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,
	 
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_PANO  
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance Acceptance
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,

	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END


GO

DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) 
-- RCalc.Edate Replaced with (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end) 
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
When RArrDet.AType<>'N' then        

 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When RArrDet.AType<>'N' then        
 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
	End
  End
 End        

Else        
	1        
End        

From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join PCalc on (PCalc.ANO=Acceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)          
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)    
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where RArrDet.AType not in ('A','C')        
and not (RArrDet.AType<>'N' and (RCover.NoRefundF=1 or RArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then ' x '+convert(varchar(25),NRArrDet.CPRefund,0)+'%' else '' end)

,        
Prorata=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then NRarrDet.CPRefund/100 else 1 end)
	             
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet NRArrDet on (NRArrDet.ANO=Acceptance.ANO and NRArrDet.FID=@P_FID)         
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=Rcalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where NRArrDet.AType<>'A' and Not (NRArrDet.AType='C' and Acceptance.EMethod='A') and RArrDet.AType not in ('A','C')        
and Not (NRArrDet.AType<>'N' and (coalesce(RCover.NoRefundF,0)=1 or NRArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Not (DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)








GO

--PATCH 2021 (51)
DROP Procedure QPCALC_ACCASS
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end) as SDate,
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, 
ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1) then coalesce(P.InstAmount,0) else coalesce(P.InstPCT,100)/100*(Case When (PCALC.Description<>'' and PCALC.Description<>'Minimum Premium') then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end) end) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)   
Left Join Payor on (Payor.ANO=@P_ANO)
Left Join APayor on (APayor.ANO=@P_ANO)  
Left Join Payor_Schedule P on (P.ANO=@P_ANO and (coalesce(APayor.ScheduleF,Payor.ScheduleF)=1 or (coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 and coalesce(APayor.DecreasePremiumF,Payor.DecreasePremiumF)=1)) and P.InstDate Between ICalc.SDate and dateadd(day,-1,ICalc.EDate))
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, 
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.SDate else coalesce(P.InstDate, ICalc.SDate) end),
(Case When coalesce(APayor.PolicyYearF,Payor.PolicyYearF)=1 then ICalc.EDate else coalesce(P.InstLDate, ICalc.EDate) end),
(Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

GO

--19 Agst 2021 : Penambahan Scheme Indemnity Rate Source
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RATE_Source' AND Object_ID = Object_ID(N'Scheme_Indemnity'))
BEGIN
ALTER TABLE Scheme_Indemnity ADD
	RATE_Source varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Rate Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Indemnity', N'COLUMN', N'RATE_Source'
END
GO

GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

GO

GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate_11' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD	
	Rate_11 float(53) NULL,
	Rate_12 float(53) NULL,
	Rate_13 float(53) NULL,
	Rate_14 float(53) NULL,
	Rate_15 float(53) NULL,
	Rate_16 float(53) NULL,
	Rate_17 float(53) NULL,
	Rate_18 float(53) NULL,
	Rate_19 float(53) NULL,
	Rate_20 float(53) NULL,
	Rate_21 float(53) NULL,
	Rate_22 float(53) NULL,
	Rate_23 float(53) NULL,
	Rate_24 float(53) NULL,
	Rate_25 float(53) NULL,
	Rate_26 float(53) NULL,
	Rate_27 float(53) NULL,
	Rate_28 float(53) NULL,
	Rate_29 float(53) NULL,
	Rate_30 float(53) NULL,
	Rate_31 float(53) NULL,
	Rate_32 float(53) NULL,
	Rate_33 float(53) NULL,
	Rate_34 float(53) NULL,
	Rate_35 float(53) NULL,
	Rate_36 float(53) NULL,
	Rate_37 float(53) NULL,
	Rate_38 float(53) NULL,
	Rate_39 float(53) NULL,
	Rate_40 float(53) NULL,
	Rate_41 float(53) NULL,
	Rate_42 float(53) NULL,
	Rate_43 float(53) NULL,
	Rate_44 float(53) NULL,
	Rate_45 float(53) NULL,
	Rate_46 float(53) NULL,
	Rate_47 float(53) NULL,
	Rate_48 float(53) NULL,
	Rate_49 float(53) NULL,
	Rate_50 float(53) NULL,
	Rate_51 float(53) NULL,
	Rate_52 float(53) NULL,
	Rate_53 float(53) NULL,
	Rate_54 float(53) NULL,
	Rate_55 float(53) NULL,
	Rate_56 float(53) NULL,
	Rate_57 float(53) NULL,
	Rate_58 float(53) NULL,
	Rate_59 float(53) NULL,
	Rate_60 float(53) NULL,
	Rate_61 float(53) NULL,
	Rate_62 float(53) NULL,
	Rate_63 float(53) NULL,
	Rate_64 float(53) NULL,
	Rate_65 float(53) NULL,
	Rate_66 float(53) NULL,
	Rate_67 float(53) NULL,
	Rate_68 float(53) NULL,
	Rate_69 float(53) NULL,
	Rate_70 float(53) NULL,
	Rate_71 float(53) NULL,
	Rate_72 float(53) NULL,
	Rate_73 float(53) NULL,
	Rate_74 float(53) NULL,
	Rate_75 float(53) NULL,
	Rate_76 float(53) NULL,
	Rate_77 float(53) NULL,
	Rate_78 float(53) NULL,
	Rate_79 float(53) NULL,
	Rate_80 float(53) NULL,
	Rate_81 float(53) NULL,
	Rate_82 float(53) NULL,
	Rate_83 float(53) NULL,
	Rate_84 float(53) NULL,
	Rate_85 float(53) NULL,
	Rate_86 float(53) NULL,
	Rate_87 float(53) NULL,
	Rate_88 float(53) NULL,
	Rate_89 float(53) NULL,
	Rate_90 float(53) NULL,
	Rate_91 float(53) NULL,
	Rate_92 float(53) NULL,
	Rate_93 float(53) NULL,
	Rate_94 float(53) NULL,
	Rate_95 float(53) NULL,
	Rate_96 float(53) NULL,
	Rate_97 float(53) NULL,
	Rate_98 float(53) NULL,
	Rate_99 float(53) NULL,
	Rate_100 float(53) NULL
END
GO

GO
DROP procedure QSchemeViewIndemnity
GO
CREATE procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select CAST(0 As Bit) ProcessFlag, S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.RateLower, S2.Rate, S2.HoldF, S2.RateLoadingF, S2.Rate_Source
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper 
go

--24 Agst 2021 : Penambahan No Prorate pada Bisnis Source
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NoProrataF' AND Object_ID = Object_ID(N'AAccBS'))
BEGIN
ALTER TABLE AAccBS ADD
	NoProrataF bit NULL
DECLARE @v sql_variant 
SET @v = N'No Prorata Flag (0 : Default Prorata, 1 : No Prorata)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AAccBS', N'COLUMN', N'NoProrataF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NoProrataF' AND Object_ID = Object_ID(N'AccBS'))
BEGIN
ALTER TABLE AccBS ADD
	NoProrataF bit NULL
DECLARE @v sql_variant 
SET @v = N'No Prorata Flag (0 : Default Prorata, 1 : No Prorata)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccBS', N'COLUMN', N'NoProrataF'
END
GO


GO
DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)                
as                
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code, A1.MSCode,          
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,         
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,  
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(0 as BIT))) END AS NOREFUNDF,        
coalesce(A5.NoProrataF, coalesce(A4.NoProrataF, coalesce(A6.NoProrataF, Cast(0 as Bit)))) as NoProrataF,
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,      
Case When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPFormula else '' end as CPFORMULA,
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCEPTANCE A2
INNER JOIN ACCASS A1 ON (A1.ANO=A2.ANO)         
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')         
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and ((R1.SDate=A3.SDate and R1.EDate=A3.EDate and A1.SDate=A2.SDate and A1.EDate=A2.EDate) or (R1.SDate=A1.SDate)))
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and A4.BSType=substring(A1.Type,2,1))        
Left Join AAccBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and A5.BSType=substring(A1.Type,2,1))       
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and A6.BSType=substring(A1.Type,2,1))       
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)      
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')      
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')     
AND A1.DepositF=0
AND Not (

(A1.TYPE in ('DI','OP') AND A1.CODE IN ('F')) or 
(A1.TYPE in ('DI','IC') AND A1.CODE IN ('D')) or
(A1.TYPE in ('CF') AND A1.CODE IN ('F','D') 
and exists (
	Select TOP 1 ACCFD.ANO
	from Coinsurance
    Inner Join ACCFD on (ACCFD.ANO=A2.ANO and ACCFD.ID=Coinsurance.ID)
    Inner join FDTAB on (FDTAB.FDID=ACCFD.FDID AND Left(FDTAB.FDTYPE,1)<>'O')
    Where Coinsurance.CNO=A2.CNO And ACCFD.CONTRIBUTIONF = 1
    and COINSURANCE.DOCNO=A1.REFNO AND COINSURANCE.PCOLLECTIONF=1 AND COINSURANCE.HF=0 AND COINSURANCE.HFAMOUNT=0
	)
)
) 



GO

DROP Function Premium_Commission
GO
CREATE Function Premium_Commission(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO 
 from Acceptance
 Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
 Where Acceptance.ANO=@P_ANO                                     
       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (  
		Case 
		When AccBS.GrossF=1 then 
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
		When AccBS.GrossBLF=1 Then
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO

GO
DROP Function Premium_Commission_VAT
GO
CREATE Function Premium_Commission_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @VAT Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO 
 from Acceptance
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)
 Where Acceptance.ANO=@P_ANO                                     

       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @VAT=        
	   sum(  
	   (  
		Case 
		When AccBS.GrossF=1 then 
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
		When AccBS.GrossBLF=1 Then
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @VAT is null                
   Select @VAT=0                
                        
 return(@VAT)                
End        

GO
DROP Function Premium_Commission_Tax
GO
CREATE Function Premium_Commission_Tax(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @TAX Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO 
 from Acceptance
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)
 Where Acceptance.ANO=@P_ANO                                     
       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @TAX=        
	   sum(  
	   (  
		Case 
		When AccBS.GrossF=1 then 
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
		When AccBS.GrossBLF=1 Then
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
	   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= cast(convert(varchar(10), getdate(),1) as smalldatetime) and coalesce(Profile.TaxHEDate,'01/01/1900')>=cast(convert(varchar(10), getdate(),1) as smalldatetime)) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= cast(convert(varchar(10), getdate(),1) as smalldatetime) and coalesce(Profile.TaxHEDate,'01/01/1900')>=cast(convert(varchar(10), getdate(),1) as smalldatetime)) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= cast(convert(varchar(10), getdate(),1) as smalldatetime) and coalesce(Profile.TaxHEDate,'01/01/1900')>=cast(convert(varchar(10), getdate(),1) as smalldatetime)) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @TAX=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= cast(convert(varchar(10), getdate(),1) as smalldatetime) and coalesce(Profile.TaxHEDate,'01/01/1900')>=cast(convert(varchar(10), getdate(),1) as smalldatetime)) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When TaxType.MTaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When TaxType.MTaxType='PASAL23' then MParam.Pasal23 When TaxType.MTaxType='PASAL26' then MParam.Pasal26 else TaxType.TaxRate end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		   Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @TAX is null                
   Select @TAX=0                
                        
 return(@TAX)                
End        
    

go

--25 Agst 2021 : Penambahan Required By dan Required Date untuk Document Checklist Polis
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDF' AND Object_ID = Object_ID(N'ACCDOCLIST'))
BEGIN
ALTER TABLE ACCDOCLIST ADD
	REQUIREDF bit NULL
DECLARE @v sql_variant 
SET @v = N'This document also Required (0 : No, 1 : yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCDOCLIST', N'COLUMN', N'REQUIREDF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDBY' AND Object_ID = Object_ID(N'ACCDOCLIST'))
BEGIN
ALTER TABLE ACCDOCLIST ADD
	REQUIREDBY varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDDATE' AND Object_ID = Object_ID(N'ACCDOCLIST'))
BEGIN
ALTER TABLE ACCDOCLIST ADD
	REQUIREDDATE smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'This document also Required (0 : No, 1 : yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCDOCLIST', N'COLUMN', N'REQUIREDF'
END
GO

GO
DROP Procedure QACCDOCLIST
GO
CREATE Procedure QACCDOCLIST(@P_ANO integer)   
as   
Select A1.ProcessFlag, A1.RequiredF, A1.RequiredBy, A1.RequiredDate, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate, A1.OptionalF, A1.REMARKS, Max(A2.ImageID) as ImageID, Count(A2.ImageID) as CountImage
from   
(   
	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(ACCDOCLIST.requiredF, 0) as bit) as requiredF, ACCDOCLIST.RequiredBy, ACCDOCLIST.RequiredDate, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, coalesce(ACCDOCLIST.REMARKS,'') as REMARKS
	from Acceptance
	Inner Join ACCDOCLIST on (ACCDOCLIST.ANO=ACCEPTANCE.OANO)
	Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
	LEFT JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC AND PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE) 
	Where Acceptance.ANO=@P_ANO   

	Union All

	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(ACCDOCLIST.requiredF, 0) as bit) as requiredF, ACCDOCLIST.RequiredBy, ACCDOCLIST.RequiredDate, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, MACCDOCLIST.DocType, MACCDOCLIST.Description, Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, coalesce(ACCDOCLIST.REMARKS,'') as REMARKS
	from ACCEPTANCE 
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO) 
	INNER JOIN ACCEPTANCE MA on (Cover.OpenFlag=1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND MA.ANO=ACCEPTANCE.LANO)
	Inner Join ACCDOCLIST MACCDOCLIST on (MACCDOCLIST.ANO=MA.OANO)
	INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC AND PDOCLIST.DOCTYPE=MACCDOCLIST.DOCTYPE) 
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
	Left Join ACCDOCLIST on (ACCDOCLIST.ANO=Acceptance.OANO and ACCDOCLIST.DOCTYPE=MACCDOCLIST.DOCTYPE)   
	Where Acceptance.ANO=@P_ANO and coalesce(ACCDOCLIST.DocType,'')=''

	Union All

	select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(ACCDOCLIST.requiredF, 0) as bit) as requiredF, ACCDOCLIST.RequiredBy, ACCDOCLIST.RequiredDate, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, PDOCLIST.DocType, PDOCLIST.Description, Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF, coalesce(ACCDOCLIST.REMARKS,'') as REMARKS
	from ACCEPTANCE 
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO) 
	INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) 
	Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
	Left Join ACCDOCLIST on (ACCDOCLIST.ANO=Acceptance.OANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
	Where Acceptance.ANO=@P_ANO and coalesce(ACCDOCLIST.DocType,'')=''
	and not exists (Select TOP 1 MACCDOCLIST.DOCTYPE FROM ACCEPTANCE MA, ACCDOCLIST MACCDOCLIST Where Cover.OpenFlag=1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO and MA.ANO=ACCEPTANCE.LANO AND MACCDOCLIST.ANO=MA.OANO)    
) A1 
Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Group By A1.ProcessFlag, A1.RequiredF, A1.RequiredBy, A1.RequiredDate, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate, A1.OptionalF, A1.REMARKS
Order By A1.DOCTYPE   


go

--31 Agustus 2021 : Penambahan Percentage untuk AutoLapse
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CPCT' AND Object_ID = Object_ID(N'ALBucket'))
BEGIN
ALTER TABLE ALBucket ADD
	CPCT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Cancellation Percentage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALBucket', N'COLUMN', N'CPCT'
END
GO
GO



--PATCH 2021 (53)
DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, A.LAmount
from Admlink A
Inner Join nVoucher V on (V.Voucher=A.Voucher)
Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 

Select Top 1 @P_DocNo=A.DocNo, @P_Date=A.Date
from @Admlink A
Order by AdmNo Desc

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

       Select V.Voucher, 
       cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
       Case 
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC*V.Rate)
       When Max(V.Payment_CC*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
       Else Max(V.Payment_CC*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End*V.Rate
       ) as Nominal_CC
       from @Admlink A
	   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B
		Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject='Premium' and B.Type=@P_Type 
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
		order by B.AdmNo Desc
		),'')
       Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End








GO

--PATCH 2021 (54)
DROP procedure QApproval_Claim 
GO
Create procedure QApproval_Claim (@P_CNO integer)            
AS            
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
	Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency, 
	Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
	Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberEstimate,  

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
	End) as PrevMemberEstimate,  
  
	Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
	Max(Case When Claim.CSeqNo>0 then (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate else 0 end) as PrevGrossAmount,  
  
	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 (CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
	End) as MemberAmount,

	Sum(
	Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
	 0  
	 else  
	 Case When Claim.CSeqNo>0 then (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate else 0 end
	End) as PrevMemberAmount
  
	From Claim  
	inner join CCALC on (CCalc.CNO=Claim.CNO)  
	inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
	Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
	Left join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency)
	WHERE Claim.CNO=@P_CNO   
	Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      


GO

--PATCH 2021 (55)
DROP Function fn_GetTotalSumInsuredByProduct
GO
CREATE Function fn_GetTotalSumInsuredByProduct(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO
DROP Function fn_GetTotalSumInsuredByPHolder
GO
CREATE Function fn_GetTotalSumInsuredByPHolder(@P_AsAt as smalldatetime, @P_PHolder as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Cover.PHolder=@P_PHolder and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total

END     
GO

DROP Function fn_GetTotalSumInsured
GO
CREATE Function fn_GetTotalSumInsured(@P_AsAt as smalldatetime,@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO

DROP Function fn_GetTotalSumInsuredByProductAndPHolder
GO
CREATE Function fn_GetTotalSumInsuredByProductAndPHolder(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_PHolder as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance, Cover
		Where Cover.CNO=Acceptance.CNO 
		and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Cover.PHolder=@P_PHolder 
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO
DROP Function fn_GetTotalSumInsuredByProductAndInsured
GO
CREATE Function fn_GetTotalSumInsuredByProductAndInsured(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_AID as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance, Cover
		Where Cover.CNO=Acceptance.CNO 
		and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.AID=@P_AID
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     


GO


--8 Sept 2021
DROP PROCEDURE View07 
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount
  else 0                
 end                
) 
+
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Premium,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
  else 0                
 end                
) 
-
sum(
 Case 
  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
  else 0 
 end
)
AS Commision,                 
sum(                
 case                 
  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS OverridingCommission,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then AccAss.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
  else 0                
 end                
) AS Acquisition,   
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
  else 0                
 end                
) AS PremiumAdjustment,                               
sum(                
 case                
  when accass.code='I' then AccAss.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Deposit,         
sum(                
 case                 
  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
  else 0                
 end                
) AS Advance,                  
dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,        
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
	)
	,Accass.Currency)
	*(Max(MParam.VAT)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT,       
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT_1,      
Case 
When Max(Admlink.AdmNo) is null then
	dbo.roundccy(
	sum(
	AccAss.Amount
	*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
	*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
	*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
	)
	,Accass.Currency)
	*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
	sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
Else 0 end
as VAT_2,       
sum(
Case 
When Admlink.Amount is null then
	dbo.roundccy(
	-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
	*(Case When Profile.TaxF=1 Then 1 Else 0 End)
	*(Case 
		When TaxType.MTaxType='PASAL21' Then 
			Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
		When TaxType.MTaxType='PASAL23' Then
			Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
		When TaxType.MTaxType='PASAL26' Then 
			Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
		When TaxType.MTaxType='PASAL4' Then 
			Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
		ELSE Profile.AccruedTax/100
		END)
	*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
	*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
	*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
	,AccAss.Currency)
When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
	Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
Else 0 end
)as TAX    
FROM Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join Branch on (Branch.Branch=Acceptance.Branch)
Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
Inner Join Mparam on (MParam.Type=AccAss.Type)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 

GO

DROP PROCEDURE View07A 
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
Declare @MRegNo as varchar(50)
Declare @MSDate as smalldatetime
Declare @MEDate as smalldatetime

Select @MRegNo=RegNo, @MSDate=SDate, @MEDate=EDate from Acceptance Where ANO=@P_ANO

if @MRegNo=''
Begin
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,                 
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,      
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_2, 
	sum(
	Case 	
	When Admlink.Amount is null then
		dbo.Roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance 
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.LANO=@P_ANO
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END
ELSE
BEGIN
	SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                
	  else 0                
	 end                
	) 
	+
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Premium,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) 
	-
	sum(
	 Case 
	  When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then AccAss.Amount 
	  else 0 
	 end
	)	
	AS Commision,                 
	sum(                
	 case                 
	  when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS OverridingCommission,                 
	sum(                
	 case                 
	  when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                
	  else 0                
	 end                
	) AS Fee,            
	sum(                
	 case                 
	  when accass.code='D' then AccAss.Amount                
	  else 0                
	 end                
	) AS Duty,                 
	sum(                
	 case                 
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' then AccAss.Amount                
	  else 0                
	 end                
	) AS Discount,                 
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                
	  else 0                
	 end                
	) AS Acquisition,   
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                
	  else 0                
	 end                
	) AS PremiumAdjustment,                               
	sum(                
	 case                
	  when accass.code='I' then AccAss.Amount                
	  else 0                
	 end                
	) AS OtherIncome,               
	sum(                
	 case                
	  when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount
	  when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount        
	  when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount        
	  else 0                
	 End                
	) AS Ujroh,              
	sum(                
	 case                
	  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                
	  else 0                
	 end                
	) AS Tabarru,         
	sum(                
	 case                
	  when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Deposit,         
	sum(                
	 case                 
	  when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO') and accass.code='J' then AccAss.Amount                
	  else 0                
	 end                
	) AS Advance,                  
	dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding, 
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When (AccAss.Type in ('BB','BA','BC','BP','OP') and Profile.VATF=1) or (AccAss.Type not in ('BB','BA','BC','BP','OP','DI','IC','CF','JP','BO') and Profile.VATF=1 and TOC.VATBusinessF=1) or (AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.VATF=1 and TOC.VATBusinessF=1) Then 1 Else 0 End)
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (8,10) then 0 else 1 end)
		)
		,Accass.Currency)
		*(Max(MParam.VAT)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT,        
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.BVATPCT,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_1,      
	Case 
	When Max(Admlink.AdmNo) is null then
		dbo.roundccy(
		sum(
		AccAss.Amount
		*(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)
		*(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)
		*(Case When Acceptance.NoRefundF<>11 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)
		)
		,Accass.Currency)
		*Max((Case When coalesce(Acceptance.TVATPCT,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)
	When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then 
		sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))
	Else 0 end
	as VAT_2, 
	sum(
	Case 
	When Admlink.Amount is null then
		dbo.roundccy(
		-(Case When AccAss.Code<>'C' or charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')=0 then AccAss.Amount Else 0 end)
		*(Case When Profile.TaxF=1 Then 1 Else 0 End)
		*(Case 
			When TaxType.MTaxType='PASAL21' Then 
				Case When MParam.PASAL21<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.Pasal21*(100-MParam.TaxDiscount)/100 end) else 0 end/100
			When TaxType.MTaxType='PASAL23' Then
				Case When MParam.PASAL23<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL23 end) else 0 end/100 
			When TaxType.MTaxType='PASAL26' Then 
				Case When MParam.PASAL26<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL26 end) else 0 end/100
			When TaxType.MTaxType='PASAL4' Then 
				Case When MParam.PASAL4<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else MParam.PASAL4 end) else 0 end/100
			ELSE Profile.AccruedTax/100
		  END)
		*Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end
		*(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C') then 0 else 1 end)
		*(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)
		,AccAss.Currency)
	When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then 
		Admlink.Amount_14*AccAss.Amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) 
	Else 0 end
	)as TAX    
	FROM Acceptance
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Inner Join TOC on (TOC.TOC=Acceptance.TOC)
	Inner Join Branch on (Branch.Branch=Acceptance.Branch)
	Inner Join Profile Insured on (Insured.ID=Acceptance.AID)
	Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)
	Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
	Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
	Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
	Inner Join Profile on (Profile.ID=AccAss.ID)
	Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	Inner Join Mparam on (MParam.Type=AccAss.Type)
	Left Join Payor MPayor on (MPayor.ANO=@P_ANO)      
	Inner Join SysTab on (1=1)
	WHERE Acceptance.RegNo=@MRegNo
	GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
	Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
	dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
	(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
END



go

--PATCH 2021 (49)
DROP function VOUCHER_AMOUNTPERIODDUE
GO
CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,        

(
Case When V.Installment=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case 
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day,A.WPC, V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 and dateadd(day,A.WPC, V.DueDate) Between @P_SDate and @P_EDate then
	(V.Nominal_CC-V.Diff_CC)-V.Payment_CC
else 0
End +
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
	else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end

Else 0
end +

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate Then 
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 
	then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +
  
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate Then  
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end +

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate Then   
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
Else 0
end as Outstanding,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
    
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)                  

)      


GO

DROP function VOUCHER_AMOUNTWPCDUE
GO
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else dateadd(day,A.WPC,V.DueDate)
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<V.Payment_CC Then 0
else V.AmountDue_1-V.Payment_CC end 
+
Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 

then V.AmountDue_17
else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V Inner Join Admlink A on (A.Voucher=V.Voucher) 
Where (Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0 or V.PDate>=@P_Date) 
) 


GO

DROP function VOUCHER_AMOUNTDUE
GO
CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Remarks, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then 0
When V.Payment_CC<(V.AmountDue_1) then (V.AmountDue_1)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2) then (V.AmountDue_1+V.AmountDue_2)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)-V.Payment_CC
When V.Payment_CC<(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23) then (V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)-V.Payment_CC
Else 0
end as AmountNextDue, 

Case 
When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 then V.DueDate_24
Else V.DueDate
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<V.Payment_CC Then 0
else V.AmountDue_1-V.Payment_CC end 
+
Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 

then V.AmountDue_17
else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
+
Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 Then '10 ' else '' end+
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end
+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment,

(
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 
	Then ' Installment 1 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_1<V.Payment_CC Then 0
	else V.AmountDue_1-V.Payment_CC end 
	+
	Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
	Then ' Installment 3 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
	else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
	+
	Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
	Then ' Installment 4 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
	else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
	+
	Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
	Then ' Installment 5 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
	else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
	+
	Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
	Then ' Installment 6 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
	else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
	+
	Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
	Then ' Installment 7 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
	else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
	+
	Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
	Then ' Installment 8 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
	else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
	+
	Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
	Then ' Installment 2 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
	else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
	+
	Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  
	Then ' Installment 10 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
	else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
	+
	Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
	Then ' Installment 11 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
	else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
	+
	Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
	Then ' Installment 12 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
	else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
	+
	Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
	Then ' Installment 13 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
	else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
	+
	Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
	Then ' Installment 14 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
	When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
	else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
	+
	Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
	Then ' Installment 15 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
	else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
	+
	Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
	Then ' Installment 16 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
	else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
	+
	Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
	Then ' Installment 17 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
	else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
	+
	Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
	Then ' Installment 18 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
	else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
	+
	Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
	Then ' Installment 19 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
	else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
	+
	Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
	Then ' Installment 20 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
	else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
	+
	Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
	Then ' Installment 21 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
	else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
	+
	Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
	Then ' Installment 22 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
	else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
	+
	Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
	Then ' Installment 23 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
	else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
	+
	Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end+ 

Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
	Then ' Installment 24 : ' + 
	convert(varchar(50), cast(
	Case 
	When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
	When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
	else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) End
	+
	Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
	as Money),1)+char(13)+char(10)
	else '' end 

) as sInstallment_Ext
from nVoucher V Inner Join Admlink A on (A.Voucher=V.Voucher) 
Where (Round(V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC,4)<>0 or V.PDate>=@P_Date) 
) 




GO


--2 Sept 2021
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
ALTER TABLE dbo.Blanket_Delivery ADD
	BlanketMoved bigint NULL,
	Status varchar(1) NULL,
	SDeliveryNo varchar(20) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Blanket Number'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'BlanketMoved'
GO
DECLARE @v sql_variant 
SET @v = N'Delivery Status (''O''pen, ''C''losed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'Status'
GO
DECLARE @v sql_variant 
SET @v = N'Source Delivery No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Blanket_Delivery', N'COLUMN', N'SDeliveryNo'
GO
Update Blanket_Delivery Set Status='O' Where Status is null
GO

ALTER TABLE [dbo].[FPartDet] DROP CONSTRAINT [FK_FPartDet__FPART]
GO

DROP INDEX [I_FPART] ON [dbo].[FPART]
GO
ALTER TABLE [dbo].[FPART] ADD  CONSTRAINT [I_FPART] PRIMARY KEY NONCLUSTERED 
(
	[ANO] ASC,
	[FID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


ALTER TABLE [dbo].[FPartDet]  WITH NOCHECK ADD  CONSTRAINT [FK_FPartDet__FPART] FOREIGN KEY([ANO], [FID], [ID])
REFERENCES [dbo].[FPART] ([ANO], [FID], [ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FPartDet] CHECK CONSTRAINT [FK_FPartDet__FPART]
GO




--VERSIONING
alter table versioning alter column vernoapp varchar(50)
go
alter table versioning alter column vernows varchar(50)
go
alter table versioning alter column vernoproclib varchar(50)
go
insert into versioning
select '2021 V.1.1.0',GETDATE(),'2021 V.1.1.0',GETDATE(),'K: 2021 V.1.1.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='58 Script Komulatif Konsol 2021 V.1.1'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
      if @PrevScript<>'' and @ExecSCript<>@PrevScript
              --THROW 51000, 'Not the Next Sequence Script', 1;
			  RAISERROR('Not the Next Sequence Script',16,1)
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              --THROW 51000, 'Pending Script Execution', 1;
			  RAISERROR('Pending Script Execution',16,1)

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End
