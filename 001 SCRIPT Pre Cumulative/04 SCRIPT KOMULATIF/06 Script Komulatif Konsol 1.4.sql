-- Perbaikan bugs fn_get_age diubah jadi fn_age

--10 Apr 2017 : Penambahan Opsi Create Profile (dulu Dump Profile adalah Opsi untuk Create Profile),
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CreateProfileF' AND Object_ID = Object_ID(N'MAP_REFERENCE'))
BEGIN
ALTER TABLE dbo.MAP_REFERENCE ADD	CreateProfileF bit NULL
DECLARE @v sql_variant 
SET @v = N'Flag Indicating ok to Create Profile when not found (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_REFERENCE', N'COLUMN', N'CreateProfileF'
END
GO

Update MAP_REFERENCE SEt CreateProfileF=DumpProfileF Where CreateProfileF is null
GO

--PERBAIKAN BUGS SCHEME VERIFY JIKA RATELOADINGF=1 DI INDEMNITY
DROP Function Get_RateLoading
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime) 
RETURNS Float AS        
  
BEGIN       
Declare @RateTab Table (
Code varchar(10),
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
SELECT Top 1 RateTab.Code, 
G1.ValueID as ValueID1,
G2.ValueID as ValueID2,
G3.ValueID as ValueID3,
G4.ValueID as ValueID4,
G5.ValueID as ValueID5,
G6.ValueID as ValueID6,
G7.ValueID as ValueID7,
G8.ValueID as ValueID8,
G9.ValueID as ValueID9,
G10.ValueID as ValueID10,
G11.ValueID as ValueID11,
G12.ValueID as ValueID12,
G13.ValueID as ValueID13,
G14.ValueID as ValueID14,
G15.ValueID as ValueID15

From AInfo 
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
 Left Join GenDTab G1 on (G1.FLDID=AInfo.FLDID1 and ((G1.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, H1.AGEMETHOD) as varchar(10)) Between G1.FLower and G1.FUpper) or (G1.Formula<>'AGE' and G1.ValueID=AInfo.ValueID1)))            
 Left Join GenDTab G2 on (G2.FLDID=AInfo.FLDID2 and ((G2.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, H2.AGEMETHOD) as varchar(10)) Between G2.FLower and G2.FUpper) or (G2.Formula<>'AGE' and G2.ValueID=AInfo.ValueID2)))             
 Left Join GenDTab G3 on (G3.FLDID=AInfo.FLDID3 and ((G3.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, H3.AGEMETHOD) as varchar(10)) Between G3.FLower and G3.FUpper) or (G3.Formula<>'AGE' and G3.ValueID=AInfo.ValueID3)))          
 Left Join GenDTab G4 on (G4.FLDID=AInfo.FLDID4 and ((G4.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, H4.AGEMETHOD) as varchar(10)) Between G4.FLower and G4.FUpper) or (G4.Formula<>'AGE' and G4.ValueID=AInfo.ValueID4)))          
 Left Join GenDTab G5 on (G5.FLDID=AInfo.FLDID5 and ((G5.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, H5.AGEMETHOD) as varchar(10)) Between G5.FLower and G5.FUpper) or (G5.Formula<>'AGE' and G5.ValueID=AInfo.ValueID5)))          
 Left Join GenDTab G6 on (G6.FLDID=AInfo.FLDID6 and ((G6.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, H6.AGEMETHOD) as varchar(10)) Between G6.FLower and G6.FUpper) or (G6.Formula<>'AGE' and G6.ValueID=AInfo.ValueID6)))          
 Left Join GenDTab G7 on (G7.FLDID=AInfo.FLDID7 and ((G7.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, H7.AGEMETHOD) as varchar(10)) Between G7.FLower and G7.FUpper) or (G7.Formula<>'AGE' and G7.ValueID=AInfo.ValueID7)))          
 Left Join GenDTab G8 on (G8.FLDID=AInfo.FLDID8 and ((G8.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, H8.AGEMETHOD) as varchar(10)) Between G8.FLower and G8.FUpper) or (G8.Formula<>'AGE' and G8.ValueID=AInfo.ValueID8)))          
 Left Join GenDTab G9 on (G9.FLDID=AInfo.FLDID9 and ((G9.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, H9.AGEMETHOD) as varchar(10)) Between G9.FLower and G9.FUpper) or (G9.Formula<>'AGE' and G9.ValueID=AInfo.ValueID9)))          
 Left Join GenDTab G10 on (G10.FLDID=AInfo.FLDID10 and ((G10.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, H10.AGEMETHOD) as varchar(10)) Between G10.FLower and G10.FUpper) or (G10.Formula<>'AGE' and G10.ValueID=AInfo.ValueID10)))          
 Left Join GenDTab G11 on (G11.FLDID=AInfo.FLDID11 and ((G11.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, H11.AGEMETHOD) as varchar(10)) Between G11.FLower and G11.FUpper) or (G11.Formula<>'AGE' and G11.ValueID=AInfo.ValueID11)))          
 Left Join GenDTab G12 on (G12.FLDID=AInfo.FLDID12 and ((G12.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, H12.AGEMETHOD) as varchar(10)) Between G12.FLower and G12.FUpper) or (G12.Formula<>'AGE' and G12.ValueID=AInfo.ValueID12)))          
 Left Join GenDTab G13 on (G13.FLDID=AInfo.FLDID13 and ((G13.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, H13.AGEMETHOD) as varchar(10)) Between G13.FLower and G13.FUpper) or (G13.Formula<>'AGE' and G13.ValueID=AInfo.ValueID13)))          
 Left Join GenDTab G14 on (G14.FLDID=AInfo.FLDID14 and ((G14.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, H14.AGEMETHOD) as varchar(10)) Between G14.FLower and G14.FUpper) or (G14.Formula<>'AGE' and G14.ValueID=AInfo.ValueID14)))          
 Left Join GenDTab G15 on (G15.FLDID=AInfo.FLDID15 and ((G15.Formula='AGE' and cast(dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, H15.AGEMETHOD) as varchar(10)) Between G15.FLower and G15.FUpper) or (G15.Formula<>'AGE' and G15.ValueID=AInfo.ValueID15)))          
WHERE AINFO.ANO=@P_ANO                       
Order by RateTab.Effective Desc

Declare @Loading as Float
Declare @Temp_Loading as Float
Select @Loading=1

--Rate Loading #1
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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


--Rate Loading #2
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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


--Rate Loading #3
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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


--Rate Loading #4
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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


--Rate Loading #5
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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

--Rate Loading #6
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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


--Rate Loading #7
Select @Temp_Loading=Null
SELECT Top 1 @Temp_Loading=RateCon.Loading
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=RateTab.Code and RateCon.AllowedF=1                 
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

Return @Loading  
END  

GO

DROP Function fn_Age
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS INT AS          
BEGIN        
declare @BirthDate as Date
declare @temp as int          
set @temp=0          
if isdate(@sBirthDate)=1 
	set @BirthDate=cast(@sBirthDate as Date)
else
	set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
 set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
  if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
   set @Temp=@Temp+1            
   End  
      else   
      Begin  
  if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End

GO


--PERBAIKAN PREMI AMOUNT JIKA MERUPAKAN DATA INFORCE BULK
DROP PROCEDURE QPREMIUMAMOUNT 
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_Date as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Select   
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end,  
@P_Date=Acceptance.ADate,
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
sum(Voucher.PremiumPaid) as PremiumPaid,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Case When sum(Voucher.PremiumPaid)<>0 Then Max(Voucher.PDate) else @P_Date End as Date          
From          
(           
 SELECT                      
 DISTINCT  
 nVoucher.Voucher,  
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
 Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                 

 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Date<=@P_PDate  
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          

GO


-- Perbaikan bugs proses claim inconsisten karena round declared
DROP procedure QInConsistent_LossItem
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)        
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=CLLOSS.INO AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
 CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)>1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)>1
)  
go

DROP Function Payor_Discount
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
Declare @OANO int

Select @PDiscount=Null
Select @GDiscount=0
Select @NDiscount=0
Select @SLoading=0
                 
 Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO from Acceptance Where ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
         from Acceptance 
         Left Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
 
         -- Payor Discount from Alternate Discount          
        Select @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount                  
        End          
        Else          
        BEGIN          
             Select @TDiscount=PayorDet.Discount from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount          
        End          
 END
                        
 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          

go

--TUNING SCRIPT UNTUK CLAIM MOVEMENT


DROP FUNCTION R_Claim_Detail
GO
Create FUNCTION R_Claim_Detail(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)
RETURNS @TCLAIM TABLE (Remarks varchar(50), Date smalldatetime, CNO int, ClaimNo varchar(20), Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle
 Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)
AS
BEGIN
Declare @P_PEDATE as SmallDatetime
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)


insert into @TClaim(Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)

Select Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current

From (

Select 
0 as OrderNo,
'Previous Claim Outstanding' as Remarks, @P_PEDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum(Gross_OS) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 
as Claim_Close, 0 as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_PEDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
1 as OrderNo,
Max(
Case 
When PClaim.CNO is null Then 'Register Claim Estimation (New)'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Re-Open Claim'
else 'Register Claim Estimation (Correction)'
end) as Remarks,
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select
2 as OrderNo,
Max(
Case 
When PClaim.CNO is null Then 'Claim Paid Settlement'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Claim Paid Settlement'
else 'Claim Paid Settlement'
end) as Remarks, 
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
3 as OrderNo,
'Claim Close/Declined' as Remarks, C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close) as Claim_Close, 0 as Claim_OS_Current
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
4 as OrderNo,
'Current Claim Outstanding' as Remarks,  @P_EDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum(Gross_OS) as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC
) C

Group By Currency, CNO, OrderNo, Date, ClaimNo, Branch, UWYear, ACYear, TOC, Remarks
Order By Currency, CNO, OrderNo, Date, ClaimNo, Branch, UWYear, ACYear, TOC, Remarks

Return
END
go



DROP Procedure GetReinsuranceRate
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT ReRate.Rate, ReRate.CCYTo   
From ReRate
Where 
ReRate.TOC=@P_TOC
and ReRate.Currency=@P_Currency
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 





go



--sompo sharia : Penambahan Account Group ketika f2 account
DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End       
       
Return                                    
END                
            

go