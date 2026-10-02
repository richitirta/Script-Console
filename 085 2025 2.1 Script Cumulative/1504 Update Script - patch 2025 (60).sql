DROP Procedure QGetClaimFacultativeLimitAndExcessUsage


GO

Create Procedure QGetClaimFacultativeLimitAndExcessUsage(@P_CNO as integer, @P_FID as varchar(20))      
as           
Select sum(C3.Limit) as Limit, sum(C3.Excess) as Excess, sum(C3.ELimit) as ELimit, sum(C3.EExcess) as EExcess
from Claim C1      
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)      
Inner Join Claim C2 on (C2.PolicyNo=A1.PolicyNo and C2.CERTIFICATENO=A1.CERTIFICATENO and C2.OCNO<>C1.OCNO)      
Inner Join CRArrDet C3 on (C3.CNO=C2.CNO and C3.FID=@P_FID)  
Where C1.CNO=@P_CNO       
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A')       
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R')      
  
GO


DROP Procedure QCLAIMFACOUT
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer,@P_SecurityF Bit=0)                    
as                    

Declare @RArrDet Table(ANO int, FID varchar(20), Limit Float, Excess Float, ELimit Float, EExcess Float)

insert into @RArrDet
Select 
RArrDet.ANO,
RArrDet.FID, 
Case 
When (RArrDet.Limit*RArrDet.RateL)>coalesce(FacUsage.Limit,0) then
	(RArrDet.Limit*RArrDet.RateL)-coalesce(FacUsage.Limit,0)
else
	0
end as Limit,
Case 
When (RArrDet.Excess*RArrDet.RateL)>coalesce(FacUsage.Excess,0) then
	(RArrDet.Excess*RArrDet.RateL)-coalesce(FacUsage.Excess,0)
else
	0
end as Excess,
Case 
When (RArrDet.Limit*RArrDet.RateL)>coalesce(FacUsage.ELimit,0) then
	(RArrDet.Limit*RArrDet.RateL)-coalesce(FacUsage.ELimit,0)
else
	0
end as ELimit,
Case 
When (RArrDet.Excess*RArrDet.RateL)>coalesce(FacUsage.EExcess,0) then
	(RArrDet.Excess*RArrDet.RateL)-coalesce(FacUsage.EExcess,0)
else
	0
end as EExcess
from 
Claim
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Outer Apply (
-- SP QGetClaimFacultativeLimitAndExcessUsage
	Select sum(C3.Limit) as Limit, sum(C3.Excess) as Excess, sum(C3.ELimit) as ELimit, sum(C3.EExcess) as EExcess
	from Claim C1      
	Inner Join Acceptance A1 on (A1.ANO=C1.ANO)      
	Inner Join Claim C2 on (C2.PolicyNo=A1.PolicyNo and C2.CERTIFICATENO=A1.CERTIFICATENO and C2.OCNO<>C1.OCNO)      
	Inner Join CRArrDet C3 on (C3.CNO=C2.CNO and C3.FID=RArrDet.FID)  
	Where C1.CNO=@P_CNO
	and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A')       
	and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R')      
) FacUsage
Where ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                               
AND RArrDet.Status='A'           
and Claim.CNO=@P_CNO


SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.ID, Profile.Name, SProfile.ID as RefID, sProfile.Name as RefName,
FPart.SlipNo, RArrDet.JPSLIPNO, FPart.Share*coalesce(FSecurity.Share,100)/100 AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,
Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>R.EExcess Then 
	Case When CArrHeader.ETAmount>(R.EExcess+R.ELimit) Then
		(R.ELimit)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount-R.EExcess)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>R.Excess  Then 
	Case When CArrHeader.TAmount>(R.Excess+R.Limit) Then
		(R.Limit)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount-R.Excess)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case
	When CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 
as Bit) end as ClaimCoopF        
From Claim
Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join @RArrDet R on (R.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=R.ANO and RArrDet.FID=R.FID)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Left Join FSecurity on (@P_SecurityF=1 and FPart.ClaimBySecurityF=1 and FSecurity.ANO=FPart.ANO and FSecurity.FID=FPart.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
Left Join Profile sProfile on (sProfile.ID=FSecurity.ID)
WHERE Claim.CNO=@P_CNO 
AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select Top 1 RateCov.Code from COL Inner Join RateCov on (RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR) Where COL.COL=Claim.COL))  
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.ID, Profile.Name, SProfile.ID as RefID, sProfile.Name as RefName,
FPart.SlipNo, RArrDet.JPSLIPNO, FPart.Share*coalesce(FSecurity.Share,100)/100 AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>R.EExcess Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>(R.EExcess+R.ELimit) Then
		(R.ELimit)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-R.EExcess)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>R.Excess Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>(R.Excess+R.Limit) Then
		(R.Limit)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-R.Excess)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL or RArrDet.Retention=0 then
		CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end	
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join COL on (COL.COL=Claim.COL)
Inner Join CArrHeader on (CarrHeader.CNO=Claim.CNO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join @RArrDet R on (R.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=R.ANO and RArrDet.FID=R.FID)
Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Left Join FSecurity on (@P_SecurityF=1 and FPart.ClaimBySecurityF=1 and FSecurity.ANO=FPart.ANO and FSecurity.FID=FPart.FID)
Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID)
Inner Join RateCov on (RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR)
Inner Join Profile on (Profile.ID=FPart.ID)
Left Join Profile sProfile on (sProfile.ID=FSecurity.ID)
Cross Apply
(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C 
	Inner Join LCALC L on (L.CNO=C.CNO and L.Currency=C.Currency)
	WHERE L.CNO=Claim.CNO AND L.TOR=COL.TOR
	GROUP BY L.CNO, L.TOR
) LCALC 
Cross Apply
(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.DEDUCTIBLE-C.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=Claim.CNO
	GROUP BY C.CNO
) CCALC 
WHERE Claim.CNO=@P_CNO 
AND RArrDet.FullCoverF=0                    
GO


insert into PatchVersioning
select '1504 Update Script - patch 2025 (60).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1504 Update Script - patch 2025 (60).sql'


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