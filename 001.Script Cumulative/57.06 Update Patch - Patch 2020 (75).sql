
insert into PatchVersioning
select '57.06 Update Patch - Patch 2020 (75)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.05 Update Patch - Patch 2020 (72) Execute After Cumulative 2020 v.1.2'
Select @CurrSCript='57.06 Update Patch - Patch 2020 (75)'


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
       
	 --    BEGIN TRY    
		--	DROP FUNCTION A
		--END TRY  
  --     BEGIN CATCH  
  --     END CATCH;

       BEGIN TRY    
			DROP FUNCTION fn_RateCon
			DROP Function Get_RateLoading
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

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
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=@P_SDate and RateTab.Code=@P_Code) 
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod=1 Then 0 Else Cover.PPeriod End)*12)>=RateCon.MinPeriod)
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod=1 Then 0 Else Cover.PPeriod End)*12)<=RateCon.MaxPeriod)     
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
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
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
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON ((RateTab.TOC=substring(Acceptance.TOC,1,len(RateTab.TOC))) and RateTab.Effective<=@P_SDate and RateTab.Code=@P_Code)       
	INNER JOIN RateCon on (    
	 RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod=1 Then 0 Else Cover.PPeriod End)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod=1 Then 0 Else Cover.PPeriod End)*12)<=RateCon.MaxPeriod)     
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


Select @AgeMethod=TOC.AgeMethod, @OANO=A.OANO, @RegID=A.RegID, @FLDID=A.FLDID, @ValueID=A.ValueID, @PHolder=C.PHolder, @SDate=@P_PDate, @EDate=A.EDate, @TOPRO=A.TOPRO, @CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0), @SPeriod=RateTab.SPeriod, @Prorata=C.PRORATA, @PPERIOD=C.PPERIOD, @ExclusiveF=A.EXCLUSIVEF, @STime=A.STime, @ETime=A.ETime
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO) Inner Join TOC on (TOC.TOC=A.TOC) Left Join TOPRO T on (T.TOPRO=A.TOPRO), RateTab
Where A.ANO=@P_ANO and RateTab.Code=@P_Code

Select @P_TSI=@P_TSI+case 
	When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@TOPRO,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@PHolder,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@RegID, @FLDID, @VALUEID,@OANO)
	else 0
	end

insert into @RateTab
SELECT Top 1 
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H1.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc1) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID2 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H2.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc2) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID3 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H3.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc3) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID4 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H4.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc4) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID5 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H5.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc5) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID6 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H6.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc6) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID7 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H7.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc7) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID8 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H8.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc8) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID9 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H9.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc9) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID10 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H10.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc10) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID11 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H11.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc11) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID12 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H12.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc12) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID13 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H13.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc13) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID14 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H14.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc14) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID15 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H15.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc15) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID15
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)             
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)      
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
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
go
