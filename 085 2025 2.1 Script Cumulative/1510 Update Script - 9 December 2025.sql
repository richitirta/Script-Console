/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TreatyDateF' AND Object_ID = Object_ID(N'Event'))

BEGIN
ALTER TABLE dbo.Event ADD
	TreatyDateF bit NULL
END
GO

DECLARE @v sql_variant 
SET @v = N'Event Date as Treaty Date References (0 : No, 1 : Yes) - Only for Event/Cat'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Event', N'COLUMN', N'TreatyDateF'
GO



DROP PROCEDURE Claim_Cession 
GO

CREATE PROCEDURE Claim_Cession (@CNO as integer, @PLossDate as smalldatetime, @pRType as varchar(255), @pReAllocF as bit=0)                    
AS                    

Declare @ClaimEvents table(TOC varchar(10), RID varchar(20))

Declare @EventNo int
Declare @ANO int
Declare @TOC varchar(10)
Declare @Category varchar(1)
Declare @PCNO int
Declare @LossDate smalldatetime

Select @PCNO=Claim.PCNO, @EventNo=Claim.EventNo, @ANO=Claim.ANO, @TOC=Claim.TOC, @Category=coalesce(Event.Category,'R'), @LossDate=Case When coalesce(Event.Category,'R')='E' and Event.TreatyDateF=1 Then Event.Date else @PLossDate end
from Claim Left Join Event on (Event.EventNo=Claim.EventNo) Where Claim.CNO=@CNO

if @EventNo>0
Begin
	if @pReAllocF=0
	Begin
		insert into @ClaimEvents
		Select Distinct C1.TOC, 
		(
			Case 
			When @pRType='X1' Then C2.XL1ID
			When @pRType='X2' Then C2.XL2ID
			When @pRType='X3' Then C2.XL3ID
			When @pRType='X4' Then C2.XL4ID
			When @pRType='X5' Then C2.XL5ID
			When @pRType='X6' Then C2.XL6ID
			When @pRType='X7' Then C2.XL7ID
			Else ''
			end) as RID
		from Claim C1
		Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
		Where @EventNo>0 and C1.EventNo=@EventNo and C2.Status='A' 
	end
	else
	Begin
		insert into @ClaimEvents
		Select Distinct C1.TOC,
		(
		Case 
		When @pRType='X1' Then C2.XL1ID
		When @pRType='X2' Then C2.XL2ID
		When @pRType='X3' Then C2.XL3ID
		When @pRType='X4' Then C2.XL4ID
		When @pRType='X5' Then C2.XL5ID
		When @pRType='X6' Then C2.XL6ID
		When @pRType='X7' Then C2.XL7ID
		Else ''
		end) as RID			 
		from Claim C1
		Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
		Where @EventNo>0 and C1.EventNo=@EventNo and C1.CType<>'C' and C1.CStatus='R' 			
	end
end

SELECT Top 1
coalesce(RePolicy.ID,'') as ID, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Limit,                    
Case When @Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Excess,                    
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
FROM Acceptance
Left Join CarrHeader pCarr on (pCarr.CNO=@pCNO and pCArr.status='A')
Inner Join Cover on (Cover.CNO=Acceptance.CNO)     
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)     
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @LossDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO
		and exists (
			Select @TOC Where R.TOC=@TOC

			union All

			Select Distinct C.TOC 
			from @ClaimEvents C
			Where C.TOC=R.TOC and C.RID=Reinsurance.RID
		)
		Order by Case When @Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@ANO
and RArrHeader.EXOLF=0        --Not Exclude XOL
and (@EventNo>0 or ReClass.EventF=0)
and (@Category<>'E' or ReClass.RiskF=0)     
and (@Category='E' or Reinsurance.Category<>'E')           
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
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET INNER JOIN LCALC ON (LCALC.CNO=@CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.EXCLUDEF=1)          
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=@CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=@ANO AND RCALC.EXTREATYF=1)     
Order By coalesce(RePolicy.ID,'') Desc, 
(Case When (@Category<>'R' and Reinsurance.Category in ('C','E')) or (@Category='R' and Reinsurance.Category in ('R')) Then 1 else 0 end) Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc


GO



DROP PROCEDURE QClaimRiskAssLimit

GO

CREATE PROCEDURE QClaimRiskAssLimit(@CNO as integer, @RType as varchar(10)='', @PLossDate as smalldatetime='')                    
AS                    
Declare @ANO Int
Declare @LossDate smalldatetime

Select @ANO=Claim.ANO, @LossDate=Case When coalesce(Event.Category,'R')='E' and Event.TreatyDateF=1 Then Event.Date else @PLossDate end
from Claim Left Join Event on (Event.EventNo=Claim.EventNo) 
Where Claim.CNO=@CNO

SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType in ('X1','X2','X3','X4','X5','X6','X7') and @LossDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))     
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@ANO
Order by                   
RiskAss.RYear Desc,        
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO

insert into PatchVersioning
select '1510 Update Script - 9 December 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1510 Update Script - 9 December 2025.sql'


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

GO 