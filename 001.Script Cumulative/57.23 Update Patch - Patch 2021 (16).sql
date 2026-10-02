
insert into PatchVersioning
select '57.23 Update Patch - Patch 2021 (16)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.22 Update Patch - Patch 2021 (15)'
Select @CurrSCript='57.23 Update Patch - Patch 2021 (16)'


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
			DROP PROCEDURE Claim_Cession 
			DROP Procedure QCLAIMRCESSION 
			DROP Procedure QGet_NumberOfEventClaimApproved
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255), @pReAllocF as bit=0)                    
AS                    
SELECT Top 1
coalesce(RePolicy.ID,'') as ID, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Limit,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Excess,                    
Reinsurance.RYear,
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 
REINSURANCE.Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Deductible, 
REINSURANCE.Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end as Aggregate, 
REINSURANCE.A_Deductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end 
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
REINSURANCE.A_EDeductible*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end 
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
REINSURANCE.A_Aggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end 
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
REINSURANCE.A_EAggregate*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end 
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
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET INNER JOIN LCALC ON (LCALC.CNO=CLAIM.CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.EXCLUDEF=1)          
And (Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,0)) end<>1 or Reinsurance.Currency=SysTab.Currency)
Order By coalesce(RePolicy.ID,'') Desc, 
(Case When (coalesce(Event.Category,'R')<>'R' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end) Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc


GO


GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Limit,
REINSURANCE.CASHLOSS*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSS, 
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



GO
Create Procedure QGet_NumberOfEventClaimApproved(@OCNO as Int, @RType as varchar(10), @RID as varchar(20))
AS
Select sum(NEventNo) as NEventNo, sum(Amount) as Amount, sum(LimitPCT) as LimitPCT
from
(
	Select count(Distinct Claim.EventNo) as NEventNo, 
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		) as Amount,
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end /
		(Case When Event.Category='E' and ReClass.ELIMIT<>0 Then ReClass.ELIMIT Else (Case WHEN ReClass.Limit=0 THEN Reinsurance.Limit Else ReClass.Limit end) End)*100
		) as LimitPCT
	from Claim
	Inner Join Event On (Event.EventNo=Claim.EventNo)          
	Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO and CArrHeader.Status='A')
	Inner Join Reinsurance on (Reinsurance.RID=@RID)
	Inner Join ReClass on (
		ReClass.RNO=Reinsurance.RNO 
		and 
		ReClass.TOC=
		(		
			Select Top 1 R.TOC
			from ReClass R
			Where R.RNO=Reinsurance.RNO 
			and 
			exists (
				Select Distinct C1.TOC 
				from Claim C1
				Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
				Where C1.EventNo=Event.EventNo and C2.Status='A' and C1.TOC=R.TOC
				and 
				Case 
				When @RType='X1' Then CArrHeader.XL1ID
				When @RType='X2' Then CArrHeader.XL2ID
				When @RType='X3' Then CArrHeader.XL3ID
				When @RType='X4' Then CArrHeader.XL4ID
				When @RType='X5' Then CArrHeader.XL5ID
				When @RType='X6' Then CArrHeader.XL6ID
				When @RType='X7' Then CArrHeader.XL6ID
				End=@RID
			)
			Order by Case When Event.Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
		)
	)
	Where Claim.EventNo>0 and Claim.OCNO<=@OCNO
	and 
	Case 
	When @RType='X1' Then CArrHeader.XL1ID
	When @RType='X2' Then CArrHeader.XL2ID
	When @RType='X3' Then CArrHeader.XL3ID
	When @RType='X4' Then CArrHeader.XL4ID
	When @RType='X5' Then CArrHeader.XL5ID
	When @RType='X6' Then CArrHeader.XL6ID
	When @RType='X7' Then CArrHeader.XL6ID
	End=@RID

	Union All

	Select 0 as NEventNo, 
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		) as Amount,
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		/
		(Case WHEN ReClass.Limit=0 THEN Reinsurance.Limit Else ReClass.Limit end)*100
		) as LimitPCT
	from Claim
	Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO and CArrHeader.Status='A')
	Inner Join Reinsurance on (Reinsurance.RID=@RID)
	Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)
	Where Claim.EventNo<=0 and Claim.OCNO<=@OCNO
	and 
	Case 
	When @RType='X1' Then CArrHeader.XL1ID
	When @RType='X2' Then CArrHeader.XL2ID
	When @RType='X3' Then CArrHeader.XL3ID
	When @RType='X4' Then CArrHeader.XL4ID
	When @RType='X5' Then CArrHeader.XL5ID
	When @RType='X6' Then CArrHeader.XL6ID
	When @RType='X7' Then CArrHeader.XL6ID
	End=@RID
) C



