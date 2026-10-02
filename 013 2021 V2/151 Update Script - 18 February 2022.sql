IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SPRShare' AND Object_ID = Object_ID(N'RARRHEADER'))
BEGIN
ALTER TABLE dbo.RARRHEADER ADD
	SPRShare float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Surplus Short Fall Retention'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RARRHEADER', N'COLUMN', N'SPRShare'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SPRAmount' AND Object_ID = Object_ID(N'RARRHEADER'))
BEGIN
ALTER TABLE dbo.RARRHEADER ADD
	SPRAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Surplus ShortFall Retention Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RARRHEADER', N'COLUMN', N'SPRAmount'
end
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
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF, Reinsurance.RShare                               
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
	 )))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When (@P_ManualF=1 or RArrHeader.ManualF=1) and (Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID) Then 1 Else 0 end Desc, coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc     



GO

DROP Procedure Treaty_Adjustment_S1
GO
CREATE Procedure Treaty_Adjustment_S1(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT REINSURANCE.RYEAR AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP1AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP1AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP1ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)
GROUP BY REINSURANCE.RYEAR    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    
          
GO

DROP Procedure Treaty_Adjustment_S2
GO
CREATE Procedure Treaty_Adjustment_S2(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT REINSURANCE.RYEAR AS RYEAR,     
MAX(REINSURANCE.RSHARE) as RSHARE,
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP2AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP2AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP2ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)
GROUP BY REINSURANCE.RYEAR    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    

GO
DROP Procedure Treaty_Adjustment_S3
GO
CREATE Procedure Treaty_Adjustment_S3(@P_ADATE smalldatetime, @P_REGID varchar(10), @P_FLDID varchar ( 255 ), @P_VALUEID varchar ( 255 ), @P_RYEAR as integer=0)    
as    
SELECT REINSURANCE.RYEAR AS RYEAR,
MAX(REINSURANCE.RSHARE) as RSHARE,     
SUM((RArrHeader.TAmount-RArrHeader.FAmount)-RARRHEADER.MAMOUNT) AS SI,    
MIN(CASE WHEN RECLASS.CESSIONF=1 THEN 1 ELSE 0 END) AS CLIMIT,    
MIN(CASE WHEN RECLASS.ASSESSMENTF=1 THEN 1 ELSE 0 END) AS RLIMIT,    
MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) AS LIMIT,    
MIN(RECLASS.PLIMIT) as PLIMIT,  
SUM((RARRHEADER.SP3AMOUNT)) as REGAMOUNT,
SUM((RARRHEADER.SP3AMOUNT)/(CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)) as AMOUNT    
From RARRHEADER, acceptance, REINSURANCE, cover, RECLASS    
WHERE COVER.CNO=ACCEPTANCE.CNO AND RECLASS.TOC=ACCEPTANCE.TOC AND RECLASS.RNO=REINSURANCE.RNO AND    
ACCEPTANCE.REGID=@P_REGID AND ACCEPTANCE.FLDID=@P_FLDID And ACCEPTANCE.VALUEID=@P_VALUEID And ACCEPTANCE.ANO=RARRHEADER.ANO and ACCEPTANCE.ASTATUS='W' and RArrHeader.Status='A' And REINSURANCE.RID=RARRHEADER.SP3ID    
And (CASE WHEN RECLASS.CESSIONF=1 THEN RARRHEADER.CLIMIT ELSE 1 END)<>0  
and (@P_RYear=0 or Reinsurance.RYear=@P_RYear)
GROUP BY REINSURANCE.RYEAR    
ORDER BY MIN(CASE WHEN RECLASS.LIMIT<>0 THEN RECLASS.LIMIT ELSE REINSURANCE.LIMIT END) DESC    


go




 insert into PatchVersioning
select '151 Update Script - 18 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='151 Update Script - 18 February 2022'


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



