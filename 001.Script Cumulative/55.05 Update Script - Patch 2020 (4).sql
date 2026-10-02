IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QREINSURANCE_CESSION 
END
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTSI, 
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
	 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
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

DROP PROCEDURE Claim_Cession 
GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                    
AS                    
SELECT 
coalesce(RePolicy.ID,''), (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Limit,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Excess,                    
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 
REINSURANCE.Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Deductible, 
REINSURANCE.A_Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as A_Deductible, 
REINSURANCE.A_EDeductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as A_EDeductible, 
REINSURANCE.Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Aggregate, 
REINSURANCE.A_Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as A_Aggregate, 
REINSURANCE.A_EAggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as A_EAggregate
FROM Claim          
Left Join Event On (Event.EventNo=Claim.EventNo)          
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)          
Inner Join Cover on (Cover.CNO=Acceptance.CNO)     
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)     
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate R1 on (R1.TOC=Claim.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
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
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)          
And (Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end<>1 or Reinsurance.Currency=SysTab.Currency)
Order By coalesce(RePolicy.ID,'') Desc, 
(Case When (coalesce(Event.Category,'R')<>'R' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end) Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc             


  

  GO
  
insert into PatchVersioning
select '55.5 Update Script - Patch 2020 (4)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.4 Update Script - Patch 2020 (3)'
Select @CurrSCript='55.5 Update Script - Patch 2020 (4)'


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






