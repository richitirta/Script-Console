IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TreatyLimitType' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	TreatyLimitType int NULL
DECLARE @v sql_variant 
SET @v = N'Treaty Limit Type (0 : 100% R/I, 1 : 100% Treaty)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'TreatyLimitType'
end
GO




DROP Procedure QCLAIMRCESSION 
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      

Declare @ClaimEvents table(TOC varchar(10), RID varchar(20))

Declare @EventNo int
Declare @ANO int
Declare @TOC varchar(10)
Declare @Category varchar(1)

Select @EventNo=Claim.EventNo, @ANO=Claim.ANO, @TOC=Claim.TOC, @Category=coalesce(Event.Category,'R') from Claim Left Join Event on (Event.EventNo=Claim.EventNo) Where Claim.CNO=@P_CNO

if @EventNo>0
Begin
	insert into @ClaimEvents
	Select Distinct C1.TOC, 
	(
		Case 
		When Reinsurance.RType='X1' Then C2.XL1ID
		When Reinsurance.RType='X2' Then C2.XL2ID
		When Reinsurance.RType='X3' Then C2.XL3ID
		When Reinsurance.RType='X4' Then C2.XL4ID
		When Reinsurance.RType='X5' Then C2.XL5ID
		When Reinsurance.RType='X6' Then C2.XL6ID
		When Reinsurance.RType='X7' Then C2.XL7ID
		Else ''
		end) as RID
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join Reinsurance on (Reinsurance.RID=@P_RID)
	Where @EventNo>0 and C1.EventNo=@EventNo and C2.Status='A' 
end


SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR,
Case When REINSURANCE.TreatyLimitType=0 or REINSURANCE.Share=0 or REINSURANCE.RType not in ('Q','A') Then 1 else 100/REINSURANCE.Share end as TreatyLimitMult,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.
Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as Limit,
CASE WHEN RPART.CASHLOSS<>0 THEN RPART.CASHLOSS ELSE REINSURANCE.CASHLOSS END*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSS, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=@ANO)
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
			Select @TOC Where R.TOC=@TOC
			
			union All

			Select Distinct C.TOC 
			from @ClaimEvents C
			Where C.TOC=R.TOC and C.RID=@P_RID
		)
		Order by Case When @Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=@ANO AND RCALC.EXTREATYF=1)     



GO

DROP Procedure CLView20
GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, 
@CNO as CNO, C1.*, C1.Estimate*C1.Share/100 as PEStimate, C1.Indemnity*C1.Share/100 as PIndemnity, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, C2.TAmount as GIndemnity, C2.ETAmount as GEstimate, Case When R3.CashLoss<>0 Then R3.CashLoss else R2.CashLoss end as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share, Case When R2.TreatyLimitType=0 or R2.Share=0 or R2.RType not in ('Q','A') Then 1 else 100/R2.Share end as TreatyLimitMult
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
	100 as Share,
	cast(1 as Float) as TreatyLimitMult
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
	100 as Share,
	cast(1 as Float) as TreatyLimitMult
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
	(C1.Type not in ('X1','X2','X3','X4','X5','X6','X7','FO') and ((C1.CLAIMCOOP>0 and C1.Estimate*C1.TreatyLimitMult>=C1.ClaimCoop) or (C1.CashCallLimit>0 and ((TOC.CashCallOnEstimateF=0 and (Case When TOC.CashCallOnGrossF=0 Then C1.Indemnity*C1.TreatyLimitMult else C1.GIndemnity end)>=C1.CashCallLimit) or (TOC.CashCallOnEstimateF=1 and (Case When TOC.CashCallOnGrossF=0 Then C1.Estimate*C1.TreatyLimitMult else C1.GEstimate end)>=C1.CashCallLimit))) or (C1.PLALimit>0 and C1.Estimate*C1.TreatyLimitMult>=C1.PLALimit)))
)
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))








GO



 insert into PatchVersioning
select '179 Update Script - 12 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='179 Update Script - 12 March 2022'


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