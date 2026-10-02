DROP Procedure QCLAIMRCESSION
GO

CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
DECLARE @TOTALINDEMNITY AS FLOAT
DECLARE @TOTALESTIMATE AS FLOAT

SELECT
	@TOTALINDEMNITY=SUM((CCALC.CLAIM-CCALC.DEDUCTIBLE-CCALC.SALVAGE)*CCALC.RATE),
	@TOTALESTIMATE=SUM((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.ESALVAGE)*CCALC.RATE)
FROM CCALC WHERE CNO=@P_CNO

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


SELECT RPART.ID, (RPART.SHARE-RPART.JP) as SHARE, cast(0 as Float) as JP, 
--CLAIM REINSURANCE PORTION
	CASE WHEN @TOTALINDEMNITY<>0 THEN
		(
			COALESCE((
				SELECT SUM((LCALC.INDEMNITY-LCALC.DEDUCTIBLE-LCALC.SALVAGE)*CCALC.RATE) FROM CCALC INNER JOIN LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY) WHERE CCALC.CNO=@P_CNO
				AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)
				AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC WHERE RCALC.ANO=@ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)
			),0)
		)
		/
		@TOTALINDEMNITY*100
	WHEN @TOTALESTIMATE<>0 THEN
		(
			COALESCE((
				SELECT SUM((LCALC.Loss-LCALC.EDEDUCTIBLE-LCALC.ESALVAGE)*CCALC.RATE) FROM CCALC INNER JOIN LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY) WHERE CCALC.CNO=@P_CNO     
				AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)    
				AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC WHERE RCALC.ANO=@ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)         
			),0)
		)
		/
		@TOTALESTIMATE*100
	ELSE
		100    
	END AS RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR, REINSURANCE.CPDAYS,
Case When REINSURANCE.TreatyLimitType=0 or REINSURANCE.Share=0 or REINSURANCE.RType not in ('Q','A') Then 1 else 100/REINSURANCE.Share end as TreatyLimitMult,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as Limit,
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
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND (RPART.SHARE-RPART.JP)<>0)
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









go



  insert into PatchVersioning
select '1289 Update Script - Patch 2025-PHI',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1289 Update Script - Patch 2025-PHI'


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