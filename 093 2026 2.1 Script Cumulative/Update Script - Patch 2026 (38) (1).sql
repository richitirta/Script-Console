DROP Procedure QREINSURANCE_CESSION
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          

Declare @Amount as float
Declare @SDate as smalldatetime
Declare @EDate as smalldatetime
Declare @RegID as varchar(10)
Declare @FLDID as varchar(255)
Declare @VALUEID as varchar(255)
Declare @EMethod as varchar(1)
Declare @ISType as varchar(1)
Declare @PHolder as varchar(10)
Declare @CGroup as varchar(10)
Declare @Segment as varchar(10)
Declare @TOC as varchar(10)
Declare @BrCurrency as varchar(10)
Declare @RYear as integer
Declare @ManualF as bit
Declare @ORBusinessF as Bit
Declare @RDate as smalldatetime
Declare @NRDate as smalldatetime

Declare @Reinsurance as table(RNO int, TOC varchar(10), ExcRate Float)

Select 
@SDate=Acceptance.SDate, 
@EDate=Acceptance.EDate,
@RegID=Acceptance.RegID, 
@FLDID=Acceptance.FLDID, 
@VALUEID=Acceptance.VALUEID, 
@EMethod=Acceptance.EMethod, 
@ISType=Cover.ISType,
@PHolder=Cover.PHOLDER,
@Segment=Cover.Segment,
@CGroup=PHolder.CGroup,
@TOC=Acceptance.TOC,
@BrCurrency=SysTab.Currency,
@RYear=Case When SysTab.RiskAccumulationByTreatyYearF=0 Then 0 else Reinsurance.RYear end,
@ManualF=coalesce(RArrHeader.ManualF,0),
@ORBusinessF=coalesce(RArrHeader.ORBusinessF,0),
@RDate=RArrHeader.RDate,
@NRDate=RArrHeader.NRDate
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Inner Join SysTab on (1=1)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
LEFT JOIN Reinsurance on (Reinsurance.RID=RArrHeader.QID)
Where Acceptance.ANO=@P_ANO

if @P_RID=''
	-- from QAccumulation
	Select @Amount=coalesce(sum(AccRegDet.Amount),0)
	from AccRegDet 
	Where (AccRegDet.RegID=@RegID and AccRegDet.FLDID=@FLDID and AccRegDet.ValueID=@ValueID and AccRegDet.RType=@P_RType AND ACCREGDET.TSI<>0 AND (ACCREGDET.RYEAR=@RYear OR @RYear=0))
else
	Select @Amount=0

Insert into @Reinsurance
Select Reinsurance.RNO, ReClass.TOC, Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=@BrCurrency Then 1 Else dbo.get_Exchange(@SDate, Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as ExcRate
From Reinsurance 
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=@TOC and (ReClass.DirectF=0 or @ISType in ('I','L','C')))      
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
WHERE Reinsurance.RType=@P_RType And 
(
(not (Reinsurance.RType='XP' and Reinsurance.POLICYRUNOFFF=1) and @P_ADATE Between Reinsurance.PDate And Reinsurance.EDate)    
or
((Reinsurance.RType='XP' and Reinsurance.POLICYRUNOFFF=1) and @SDate Between Reinsurance.PDate And Reinsurance.EDate)    
)
and Reinsurance.Status='A'

SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*R.ExcRate as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate as limit, 
ReClass.ShortFallLimit*R.ExcRate  as ShortFallLimit,              
ReClass.MinTSI*R.ExcRate  as MinTSI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, @FLDID as FLDID, @VALUEID as VALUEID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF,
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF, Reinsurance.RShare                               
From @Reinsurance R
Inner Join Reinsurance on (Reinsurance.RNO=R.RNO)
Inner Join ReClass on (ReClass.RNO=R.RNO and ReClass.TOC=R.TOC)
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE Reinsurance.RType=@P_RType
And (@P_RID='' or Reinsurance.RID=@P_RID or @ManualF=0 or @EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=@PHolder)    
And (@P_ManualF=1 or @ManualF=1 or  
(
	(      
	 (Reinsurance.ORBusinessF=@ORBusinessF)      
	 And (@P_TSI>=ReClass.MinTSI*R.ExcRate  or ReClass.MinTSI*R.ExcRate =0) 
	 and (@P_TSI<=ReClass.MaxTSI*R.ExcRate  or ReClass.MaxTSI*R.ExcRate =0) 
	 and (@P_GROSS>=ReClass.MinGross*R.ExcRate  or ReClass.MinGross*R.ExcRate =0) 
	 and (@P_GROSS<=ReClass.MaxGross*R.ExcRate  or ReClass.MaxGross*R.ExcRate =0)                 
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))>=ReClass.MinPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MinPeriod-1 and day(coalesce(@RDate,@SDate))<day(coalesce(@NRDate,@EDate)))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))<ReClass.MaxPeriod)     
	 or (datediff(month, coalesce(@RDate,@SDate), coalesce(@NRDate,@EDate))=ReClass.MaxPeriod and day(coalesce(@RDate,@SDate))>=day(coalesce(@NRDate,@EDate)))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=@Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=@CGroup))
	 )))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=@P_ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate>@Amount then 0 else 1 End,
Case When (@P_ManualF=1 or @ManualF=1) and (Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID) Then 0 Else 1 end, 
coalesce(RePolicy.ID,'') Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc,
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*R.ExcRate-@Amount,
Reinsurance.PDate Desc

GO