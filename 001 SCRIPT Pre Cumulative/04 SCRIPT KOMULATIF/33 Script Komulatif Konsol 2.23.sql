--23 okt 2017 

DROP Function Get_TaxType
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20), @P_TaxNominal as float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float

Select @TaxType=TaxType from TaxType Where TaxType=@P_TaxType and coalesce(Lower,0)=0 and coalesce(Upper,0)=0
 
if @TaxType is null
Begin


	Select @PNominal_Tax=sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*SL.Rate*pVoucher.Rate)+@P_TaxNominal
	from pSL SL, pVoucher, nVoucher V, Admlink A
	where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
	and A.Type in ('BB','BA','BC')
	and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
	and A.ID=@P_ID
	and pVoucher.Voucher<>@P_PVoucher

	if @Pnominal_Tax is null
		Select @PNominal_Tax=0

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
  
END    

go

--9 Nov 2017 

DROP Procedure QCLAIMFACOUT
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,        

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,        

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100)
 Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 

(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, 
Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,     

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,      

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

(
SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
FROM LCALC L, CCALC C 
WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
GROUP BY L.CNO, L.TOR
) LCALC,
(
SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C
WHERE C.CNO=@P_CNO
GROUP BY C.CNO
) CCALC
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
AND RArrDet.Status='A'     

                            
GO

Select * into #MPARAM from MParam Where Type='FO'
UPDATE #MPARAM SET TYPE='FP', Remarks='FACULTATIVE JOINT PLACEMENT'
INSERT INTO MPARAM SELECT * FROM #MPARAM
DROP TABLE #MPARAM
go

--6 nov 2017 : inisialisasi
UPDATE ADMLINK SET PAYMENT=0 WHERE PAYMENT IS NULL
go


Drop index Admlink.I_Admlink_Extra_1
GO
Drop index Admlink.I_Admlink_ID
GO
Drop index Admlink.I_Admlink_Subject
GO
Drop index Admlink.I_Admlink_Type
go

--perbaikan 10 nov 2017
DROP function VOUCHER_REMINDERDUE
GO
CREATE function VOUCHER_REMINDERDUE(@P_Reminder as int, @P_Date as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Date, V.Branch, V.VType, V.ProAcc, V.RefNo, V.SL_Cat, V.Remarks, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF,      
      
      
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountDue,  
    
V.Nominal_CC-V.Diff_CC-
      
(Case When V.Installment=0 and datediff(day, V.DueDate, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) Then V.AmountDue_24 else 0 end
) as AmountUnDue,     
            
Case When V.Installment=0 then V.DueDate   
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   
Else V.DueDate_24   
end as DueDate,   
(Case When V.Installment<>0 then ' Installment No. ' else '' end+   
Case When V.Installment>=1 and datediff(day, V.DueDate_1, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+   
Case When V.Installment>=2 and datediff(day, V.DueDate_2, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+   
Case When V.Installment>=3 and datediff(day, V.DueDate_3, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+   
Case When V.Installment>=4 and datediff(day, V.DueDate_4, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+   
Case When V.Installment>=5 and datediff(day, V.DueDate_5, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+   
Case When V.Installment>=6 and datediff(day, V.DueDate_6, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+   
Case When V.Installment>=7 and datediff(day, V.DueDate_7, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+   
Case When V.Installment>=8 and datediff(day, V.DueDate_8, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+   
Case When V.Installment>=9 and datediff(day, V.DueDate_9, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+   
Case When V.Installment>=10 and datediff(day, V.DueDate_10, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+   
Case When V.Installment>=11 and datediff(day, V.DueDate_11, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and datediff(day, V.DueDate_12, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+   
Case When V.Installment>=13 and datediff(day, V.DueDate_13, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+   
Case When V.Installment>=14 and datediff(day, V.DueDate_14, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+   
Case When V.Installment>=15 and datediff(day, V.DueDate_15, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+   
Case When V.Installment>=16 and datediff(day, V.DueDate_16, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+   
Case When V.Installment>=17 and datediff(day, V.DueDate_17, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+   
Case When V.Installment>=18 and datediff(day, V.DueDate_18, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+   
Case When V.Installment>=19 and datediff(day, V.DueDate_19, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+   
Case When V.Installment>=20 and datediff(day, V.DueDate_20, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+   
Case When V.Installment>=21 and datediff(day, V.DueDate_21, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+   
Case When V.Installment>=22 and datediff(day, V.DueDate_22, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+   
Case When V.Installment>=23 and datediff(day, V.DueDate_23, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+   
Case When V.Installment>=24 and datediff(day, V.DueDate_24, @P_Date)>=(Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+   
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
   
from nVoucher V 
inner join Admlink A On (A.Voucher=V.Voucher) 
inner join Reminder R on (R.Reminder=@P_Reminder) 
Left Join ReminderD RD on (R.Reminder=RD.Reminder and RD.ID=A.Source and RD.ISType=A.ISType)      
Where V.Date<=@P_Date  
and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)      
and Exists (Select A4.A_PolicyNo from nVoucher Voucher, Admlink A4 Where A4.Voucher=Voucher.Voucher and A4.Type=A.Type and A4.Subject=A.Subject and A4.A_PolicyNo=A.A_PolicyNo and A4.ID=A.ID and A4.Currency=A.Currency and A4.RefNo=A.RefNo Group by A4.A_PolicyNo having round(sum(Case When Voucher.DebtorF=1 Then (Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC) Else -(Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC) End),2)>0)
and datediff(day,
Case When V.Installment=0 then V.DueDate   
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22   
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23   Else V.DueDate_24   end, @P_Date) Between (Case When RD.ID is null then R.Day_1 else RD.Day_1 end) and (Case When RD.ID is null then R.Day_2 else RD.Day_2 end)      
)      



go
--Update Inisialisasi PCT LOSS
Update SI1 Set PADDITION=S1.PADDITION
From 
Scheme_Indemnity S1 
Inner Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper) 
Where coalesce(SI1.PADDITION,0)=0
go
Update SI1 Set PCTLOSS=S1.PCTLOSS
From 
Scheme_Indemnity S1 
Inner Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper) 
Where coalesce(SI1.PCTLOSS,0)=0
go


--FEE AMOUNT
DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
             Select 
             @P_FEE=
             Case 
             When @P_FDTYPE<>'O' Then 
                     Case 
                     When @P_AmountPCTBased=0 then
                           sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
                    Else
                           Max(P.OurShare*(100-R.MSHARE)/100)
                    End
           Else
                    Case
                    When @P_AmountPCTBased=0 then
                           sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI)
                    Else
                           Max(P.OurShare)
                    End
             End*@P_AmountPCT/100
             from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
             Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
             and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
ELSE   -- Fleet Only
             SELECT @P_FEE=SUM(FEE)
             FROM
             (
                    SELECT
                    ACCEPTANCE.ANO,
                    (
                           Select 
                           Case 
                           When @P_FDTYPE<>'O' Then 
                                 Case
                                 When @P_AmountPCTBased=0 then
                                        sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
                                 Else
                                        Max(P.OurShare*(100-R.MSHARE)/100)
                                 End
                           ELSE 
                                 Case
                                 When @P_AmountPCTBased=0 then
                                        sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI)
                                 Else
                                        Max(P.OurShare)
                                 End
                           End*@P_AmountPCT/100
                           from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                           Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
                           and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
                    ) as FEE
                    FROM ACCEPTANCE, COVER
                    WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
             ) A
SELECT @P_FEE AS FEE

GO


--update script

DROP Function Get_TaxType
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20), @P_TaxNominal as float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float

Select @TaxType=TaxType from TaxType Where TaxType=@P_TaxType and coalesce(Lower,0)=0 and coalesce(Upper,0)=0
 
if @TaxType is null
Begin


	Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*SL.Rate*pVoucher.Rate),0)
	from pSL SL, pVoucher, nVoucher V, Admlink A
	where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
	and A.Type in ('BB','BA','BC')
	and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
	and A.ID=@P_ID
	and pVoucher.Voucher<>@P_PVoucher

    Select @PNominal_Tax = @PNominal_Tax + @P_TaxNominal

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
  
END    





go

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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Profile_Ext ADD
	ID_Date_Ext smalldatetime NULL,
	ID_No_Ext varchar(30) NULL,
	ID_Name_Ext varchar(255) NULL,
	ID_Type_Ext varchar(10) NULL
GO
ALTER TABLE dbo.Profile_Ext SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
go

-- MENGHAPUS CONSRAINT DI SYSBATCHORIGINAL
Alter Table SysBatchOriginalUp Drop Constraint FK_SysBatchOriginalUp_SysBatchH
GO
Alter Table SysBatchOriginalSC Drop Constraint FK_SysBatchOriginalSC_SysBatchH
GO
Alter Table SysBatchOriginalBe Drop Constraint FK_SysBatchOriginalBe_SysBatchH
GO
Alter Table SysBatchOriginalBC Drop Constraint FK_SysBatchOriginalBC_SysBatchH
go

--penambahan drate untuk exchange rate
ALTER TABLE ARBucket ADD dRate Real
GO

--VERSIONING
insert into versioning
select '2017 V.2.23.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
