/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

DROP INDEX I_RPart_DocNo_ID ON dbo.RPART
GO
ALTER TABLE RPART NOCHECK CONSTRAINT ALL
GO

ALTER TABLE dbo.RPART ADD CONSTRAINT
	I_RPART_DOCNO_ID UNIQUE NONCLUSTERED 
	(
	DOCNO,
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

ALTER TABLE RPART CHECK CONSTRAINT ALL
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ODOCNO' AND Object_ID = Object_ID(N'RPART'))

BEGIN
ALTER TABLE dbo.RPART ADD
	ODOCNO varchar(20) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Original Doc No (ODOCNO=DOCNO for New Record)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPART', N'COLUMN', N'ODOCNO'
GO


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	Status varchar(1) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PDATE' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	PDATE smalldatetime NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	AUserID varchar(50) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	AUserDate smalldatetime NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserID' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	CUserID varchar(50) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserDate' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	CUserDate smalldatetime NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VSEQNO' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	VSEQNO int NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ORID' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	ORID varchar(20) NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ODOCNO' AND Object_ID = Object_ID(N'REINSURANCE'))

BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	ODOCNO varchar(20) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Reinsurance Data Status (''R'' equest,''A''pproved,''C''ancel)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'Status'
GO
DECLARE @v sql_variant 
SET @v = N'Effective Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'PDATE'
GO
DECLARE @v sql_variant 
SET @v = N'Approval User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'AUserID'
GO
DECLARE @v sql_variant 
SET @v = N'Approval User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'AUserDate'
GO
DECLARE @v sql_variant 
SET @v = N'Cancel User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'CUserID'
GO
DECLARE @v sql_variant 
SET @v = N'Cancel User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'CUserDate'
GO
DECLARE @v sql_variant 
SET @v = N'Revision Sequence No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'VSEQNO'
GO
DECLARE @v sql_variant 
SET @v = N'Original RID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'ORID'
GO
DECLARE @v sql_variant 
SET @v = N'Original DocNo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'ODOCNO'
GO
ALTER TABLE dbo.REINSURANCE SET (LOCK_ESCALATION = DISABLE)
GO


insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWAPPROVETREATYSETTING', 'ALLOW APPROVE TREATY SETTING', 'ACTIVITIES',0

GO

insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCANCELTREATYSETTING', 'ALLOW CANCEL TREATY SETTING', 'ACTIVITIES',0

GO

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
WHERE Reinsurance.RType=@P_RType And @P_ADATE Between Reinsurance.SDate And Reinsurance.EDate    
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

SELECT 
coalesce(RePolicy.ID,'') as ID, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.
Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) end as Limit,                    
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
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @LossDate Between Reinsurance.SDate And Reinsurance.EDate and Reinsurance.Status='A')          
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
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)
)
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
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc,
Reinsurance.PDate Desc

GO



insert into PatchVersioning
select '1581 Update Script - 18 April 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1581 Update Script - 18 April 2026.sql'


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