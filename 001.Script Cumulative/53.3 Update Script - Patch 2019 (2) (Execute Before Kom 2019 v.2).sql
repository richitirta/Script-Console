
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RateLoading') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  Get_RateLoading
end
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512))   
AS     
BEGIN       
Declare @RateTab Table (
Code varchar(10),
SPeriod Int,
SDate smalldatetime, 
EDate smalldatetime,
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

insert into @RateTab
SELECT Top 1 
RateTab.Code, 
RateTab.SPeriod,
Acceptance.Sdate,
Acceptance.EDate,
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID1 and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID2 and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID3 and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID4 and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID5 and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID6 and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID7 and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID8 and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID9 and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID10 and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID11 and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID12 and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID13 and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID14 and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.Formula='AGE' and G.FLDID=AInfo.FLDID15 and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))) as ValueID15

From Acceptance
 INNER JOIN AINFO on (AINFO.ANO=ACCEPTANCE.ANO)
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
WHERE ACCEPTANCE.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)


Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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


--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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


--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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


--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MinPeriod-1 and day(RateTab.sdate)<day(RateTab.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, RateTab.sdate, RateTab.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, RateTab.sdate, RateTab.edate)=RateCon.MaxPeriod and day(RateTab.sdate)>=day(RateTab.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, RateTab.sdate, RateTab.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, RateTab.sdate, RateTab.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
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

insert into @RateCon Select @Loading, @HoldF,@HoldMessage
Return
END  
 go



  insert into PatchVersioning
select '53.3 Update Script - Patch 2019 (2) (Execute Before Kom 2019 v.2)',GETDATE()
go
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='53.2 Update Script - Patch 2019 (1) (Execute Before Kom 2019 v.2)'
Select @CurrSCript='53.3 Update Script - Patch 2019 (2) (Execute Before Kom 2019 v.2)'


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