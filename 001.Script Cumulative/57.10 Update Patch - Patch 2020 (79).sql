
insert into PatchVersioning
select '57.10 Update Patch - Patch 2020 (79)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.9 Update Patch - Patch 2020 (78)'
Select @CurrSCript='57.10 Update Patch - Patch 2020 (79)'


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
			DROP Procedure CLView20
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, 
@CNO as CNO, C1.*, C1.Estimate*C1.Share/100 as PEStimate, C1.Indemnity*C1.Share/100 as PIndemnity, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share
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
	100 as Share
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
	100 as Share
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
	(C1.Type not in ('X1','X2','X3','X4','X5','X6','X7','FO') and ((C1.CLAIMCOOP>0 and C1.Estimate>=C1.ClaimCoop) or (C1.CashCallLimit>0 and C1.Indemnity>=C1.CashCallLimit) or (C1.PLALimit>0 and C1.Estimate>=C1.PLALimit)))
)
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))

GO
