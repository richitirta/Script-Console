IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Retention' AND Object_ID = Object_ID(N'RARRDET'))
BEGIN
ALTER TABLE dbo.RARRDET ADD
	Retention float(53) NULL
end
GO

DROP Procedure QFacultative_Data
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.RETENTION, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF, R.NotApplyDiscountCFF,
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM, F.CPDays,
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.DiscAmount, F.BRID, F.BRComm,
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R
INNER JOIN FPART F on (F.ANO=R.ANO AND F.FID=R.FID)
WHERE R.ANO=@P_ANO AND R.FID=@P_FID


GO

DROP Procedure QFACOUT
GO
CREATE Procedure QFACOUT(@P_ANO integer)      
as      
SELECT RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Retention, RArrDet.Prorata, Profile.Name,     
FPart.SlipNo, FPart.SlipRetF, FPart.ID, FPart.Share AS RShare, FPart.Comm, FPart.WPC,      
FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.FullCoverF, RArrDet.OriginalF, RArrDet.PrecedeFacCessionF, FPart.Remarks,
FPart.Grace, FPart.Installment, RArrDet.AcceptedBy, RArrDet.AcceptedDate 
From RArrDet
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
WHERE RArrDet.ANO=@P_ANO

GO

DROP Procedure QCLAIMFACOUT
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Retention, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess+RArrDet.Limit Then
		(RArrDet.Limit)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount-RArrDet.Excess) *(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100>RArrDet.Retention then
		CArrHeader.ETAmount*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100-RArrDet.Retention
	else
		0
	end
End
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then 
	Case When CArrHeader.TAmount>RArrDet.Excess+RArrDet.Limit Then
		(RArrDet.Limit)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount-RArrDet.Excess) *(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case
	When CArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100>RArrDet.Retention then
		CArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100-RArrDet.Retention
	else
		0
	end
End
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select Top 1 RateCov.Code from COL Inner Join RateCov on (RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR) Where COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Retention, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		(RArrDet.Limit)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100>RArrDet.Retention then
		CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100-RArrDet.Retention
	else
		0
	end
End
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		(RArrDet.Limit)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100>RArrDet.Retention then
		CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100-RArrDet.Retention
	else
		0
	end	
End
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join COL on (COL.COL=Claim.COL)
Inner Join CArrHeader on (CarrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID)
Inner Join RateCov on (RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR)
Inner Join Profile on (Profile.ID=FPart.ID)
Inner Join 
(
SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C 
Inner Join LCALC L on (L.CNO=C.CNO and L.Currency=C.Currency)
WHERE C.CNO=@P_CNO
GROUP BY L.CNO, L.TOR
) LCALC on (LCALC.CNO=Claim.CNO AND LCALC.TOR=COL.TOR)
Inner Join
(
SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C
WHERE C.CNO=@P_CNO
GROUP BY C.CNO
) CCALC on (CCALC.CNO=Claim.CNO)
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=0                    
AND RArrDet.Status='A'     



go


 insert into PatchVersioning
select '273 Update Script - 27 May 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='273 Update Script - 27 May 2022'


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
