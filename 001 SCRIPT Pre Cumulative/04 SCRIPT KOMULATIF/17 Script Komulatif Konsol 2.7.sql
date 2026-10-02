--16 agst 2017 :PERUBAHAN PROSES CARESVC AGAR PROCESS SC DAPAT DILAKUKAN SECARA PARALEL.. 
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
ALTER TABLE dbo.SysProcess ADD
	MainProcName varchar(100) NULL
GO
ALTER TABLE dbo.SysProcess SET (LOCK_ESCALATION = TABLE)
GO
Update SysProcess Set MainProcName=ProcName from SysProcess Where MainProcName is null
COMMIT

--18 AGST 2017 : Penambahan Commission in Amount di Facultative
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
ALTER TABLE dbo.FPART ADD
	CommAmount float(53) NULL,
	OCommAmount float(53) NULL,
	Discount float(53) NULL,
	ProfitSharing float(53) NULL,
	BRID varchar(10) NULL,
	BRComm float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Reinsurance Commission in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'CommAmount'
GO
DECLARE @v sql_variant 
SET @v = N'Reinsurance Overriding Commission in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'OCommAmount'
GO
DECLARE @v sql_variant 
SET @v = N'Premium Discount (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'Discount'
GO
DECLARE @v sql_variant 
SET @v = N'% Profit Sharing Return'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'ProfitSharing'
GO
DECLARE @v sql_variant 
SET @v = N'Broker Re Profile ID (see Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'BRID'
GO
DECLARE @v sql_variant 
SET @v = N'Broker Re Comm (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'BRComm'
GO
ALTER TABLE dbo.FPART SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO
DROP Procedure QFACOUTDET
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.OCommAmount, FPart.Discount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.OCommAmount,FPart.Discount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      

GO


DROP Procedure QFacultative_Data
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,             
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.BRID, F.BRComm,
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
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   


GO
DROP FUNCTION FN_ICALC 
GO
Create FUNCTION FN_ICALC (@P_ANO as integer) 
RETURNS Table 
AS RETURN ( 
SELECT  ICALC.ANO, 
Count(Distinct PCalc.Currency) AS NUMCCY, 
MAX(PCALC.RATE) AS RATE, 
Max(PCALC.TSI*PCalc.Rate) AS TSI, 
sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate) AS Gross 
FROM  ICALC 
INNER JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY) 
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0 
GROUP BY ICALC.ANO 
) 
 
GO

DROP FUNCTION FN_RCALC 
GO
Create FUNCTION FN_RCALC (@P_ANO as integer,@P_RCode as varchar(10), @P_Year as integer)
RETURNS Table 
AS RETURN ( 
SELECT  ICALC.ANO, 
Count(Distinct PCalc.Currency) AS NUMCCY, 
MAX(PCALC.RATE) AS RATE, 
sum(ICALC.TSI*PCalc.Rate) AS TSI, 
sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate) AS Gross 
FROM  ICALC 
INNER JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY) 
INNER JOIN ACCEPTANCE on (ACCEPTANCE.ANO=ICALC.ANO)
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0 
and ICalc.Code=@P_RCode and (@P_Year=0 or (dateadd(year,@P_Year-1,Acceptance.SDate)>=ICalc.SDate and dateadd(year,@P_Year-1,Acceptance.SDate)<ICalc.EDate))  
GROUP BY ICALC.ANO 
) 

 



go


--AUTORECEIPTPAYMENT_PROCESS


ALTER TABLE dbo.RPBUCKET ADD NVOUCHER varchar(20)
go
ALTER TABLE dbo.RPBUCKET ADD PAYMENT Float
go
ALTER TABLE dbo.RPBUCKET ADD PAYMENT_DATE smalldatetime
go
ALTER TABLE dbo.RPBUCKET ADD PAYMENT_BACKDATEDF Bit
GO


--21 agst 2017 :OPSI AUTO GENERATE COLLECTION
DROP function VOUCHER_AMOUNTDUE
GO
CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
 
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
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V
.DueDate_16 
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
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' 
else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V 
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 

GO

DROP function VOUCHER_AMOUNTWPCDUE
GO
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Branch, V.CollNo, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate) 
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
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher) 
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 
 

GO

/****** Object:  UserDefinedFunction [dbo].[CL_U_COLLECT]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_U_COLLECT]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_D_COLLECT]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_D_COLLECT]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SUBROGATION]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SUBROGATION]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SALVAGE]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SALVAGE]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_MAIPARK]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_MAIPARK]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_BPPDAN]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_BPPDAN]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_NEW]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_END]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_ALL]
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  
  
  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE function [dbo].[CL_A_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  
  
  
  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--


CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--


CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--


--


CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--


--


CREATE function [dbo].[CL_A_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_A_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--


CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--


CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and ((Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')) or (Admlink.Type in ('OP') and Admlink.Amount_8+Admlink.Amount_10<>0))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  
  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_BPPDAN]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_BPPDAN] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('CP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_FACULTATIVE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FO')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_MAIPARK]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_MAIPARK] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('XP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SALVAGE]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[CL_C_COLLECT_ALL_SALVAGE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))      
RETURNS TABLE      
AS RETURN      
(      
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,       
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,      
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code      
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink      
where  Voucher.Voucher=AdmLink.Voucher       
and ProAcc.ProAcc=Voucher.ProAcc       
and ProAcc.[ID]=[Profile].[ID]       
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) --Salvage/Excess    
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate      
and Admlink.Voucher=Voucher.Voucher      
and Admlink.Subject='Claim'      
and Profile.ID Like @P_ID+'%'      
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)       
)      


GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SUBROGATION]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE function [dbo].[CL_C_COLLECT_ALL_SUBROGATION] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('OP') and Admlink.Amount_10<>0	--Subrogation
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  
  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DC','QS','QP','S1','S2','S3','AF','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY_XOL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)

























GO

/****** Object:  UserDefinedFunction [dbo].[CL_D_COLLECT]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[CL_D_COLLECT](@P_CollNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
Select C1.RefNo as NoGrouping, Admlink.A_PolicyNo as NoPolis, Admlink.RefNo as NoKontrak, C2.Amount, (Select Count(*) from CollectionV Where CollNo=@P_CollNo) as JumlahKontrak, C3.TAmount as TotalAmount 
from CollectionH C1, CollectionV C2, CollAmount C3, Admlink 
Where C2.CollNo=C1.CollNo and C3.CollNo=C1.CollNo and C3.Currency=C2.Currency and Admlink.Voucher=C2.Voucher 
and C1.CollNo=@P_CollNo 
) 
 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,A.A_PolicyNo,V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('BB','BA','BO')
and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  


GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,A.A_PolicyNo,V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('DI','IC','CF','JP','SO') and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  


GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[CL_F_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,A.A_PolicyNo, V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('BB','BA','BO','DI','IC','CF','JP','SO') and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  



GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_F_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















CREATE function [dbo].[CL_F_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE function [dbo].[CL_I_COLLECT_ALL_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
)  











GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_ALL_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

--

CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--
--

CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

--

CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_I_COLLECT_NOT_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_I_COLLECT_NOT_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)


















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO](@P_ANO as Int)  
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
)



GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO](@P_ANO as int)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)
)  




GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

















--

CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--


CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_R_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','IR','IT','IX')   
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)







GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)





GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_END]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]    Script Date: 8/21/2017 5:45:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher) 

)









GO

/****** Object:  UserDefinedFunction [dbo].[CL_U_COLLECT]    Script Date: 8/21/2017 5:45:22 PM ******/

CREATE function CL_U_COLLECT(@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
select Voucher.RefNo,Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code, 
Admlink.AccountNo, Admlink.Extra_4 
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink 
where Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C') 
and Admlink.Subject='Premium' 
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
) 

go

--21 agst 2017 (1) : Setting Auto Number Pada Virtual Account
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
ALTER TABLE dbo.VAccount ADD
	AutoNum varchar(5) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Auto Generate Numbering Format (see AutoNum)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccount', N'COLUMN', N'AutoNum'
GO
ALTER TABLE dbo.VAccount SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--21 agst 2017 : claim history

DROP Procedure PI07
GO
CREATE Procedure PI07(@P_ANO as integer)  
as  
    
select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO)
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and Exists
(
Select A2.ANO from Acceptance A1, Acceptance A2 
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO
Union All
Select A3.ANO from Acceptance A1, Acceptance A2, Acceptance A3 
Where A1.ANO=@P_ANO and A2.ANO=A1.RANO and A3.OANO=A2.OANO
Union All
Select A4.ANO from Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4
Where A1.ANO=@P_ANO and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.OANO=A3.OANO
)
Order by Claim.LossDate Desc

go

--Perbaikan bugs tidak bisa inquiry batchno & asource
DROP function ListQry_3
GO
CREATE function ListQry_3 (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,              
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab  
WHERE  Cover.CNO=Acceptance.CNO     
 and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.toc like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,   
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab  
Where cover.CNO = acceptance.CNO     
 And cover.PHolder = Profile.ID              
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union        
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)              
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO)   
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO        
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID               
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   
GO
DROP function ListQry_3_A
GO
Create function ListQry_3_A (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)      
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Q.[COVERNO],      
 Q.[Insured],      
 Q.[CNO],      
 Q.[CStatus],      
 Q.[lANO],      
 Q.[ANO],      
 Q.[REGNO],      
 Q.[ADATE],      
 Q.[USERID],      
 Q.[Currency],       
 Q.[ASTATUS],      
 Q.[ATYPE],      
 Q.[SDate],      
 Q.[EDate],      
 Q.RYear,      
 Q.[ISType],      
 Q.[Renewal],      
 Q.[ESeqNo],      
 Q.[PolicyNo],      
 Q.[CertificateNo],      
 Q.RefNo,      
 Q.ProformaF,      
 A.FLDID1,      
 A.VALUEID1,      
 A.VALUEDESC1,      
 A.FLDID2,      
 A.VALUEID2,      
 A.VALUEDESC2,      
 A.FLDID3,      
 A.VALUEID3,      
 A.VALUEDESC3,      
 A.FLDID4,      
 A.VALUEID4,      
 A.VALUEDESC4,      
 A.FLDID5,      
 A.VALUEID5,      
 A.VALUEDESC5,      
 A.FLDID6,      
 A.VALUEID6,      
 A.VALUEDESC6,      
 A.FLDID7,      
 A.VALUEID7,      
 A.VALUEDESC7,      
 A.FLDID8,      
 A.VALUEID8,      
 A.VALUEDESC8,      
 A.FLDID9,      
 A.VALUEID9,      
 A.VALUEDESC9,      
 A.FLDID10,      
 A.VALUEID10,      
 A.VALUEDESC10,      
 A.FLDID11,      
 A.VALUEID11,      
 A.VALUEDESC11,      
 A.FLDID12,      
 A.VALUEID12,      
 A.VALUEDESC12,      
 A.FLDID13,      
 A.VALUEID13,      
 A.VALUEDESC13,      
 A.FLDID14,      
 A.VALUEID14,      
 A.VALUEDESC14,      
 A.FLDID15,      
 A.VALUEID15,      
 a.VALUEDESC15      
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) AS Q, AINFO AS A      
Where q.ano_info = a.ANO      
)      

GO

DROP function ListQry_3b
GO
CREATE function ListQry_3b (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as varchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Cover, Acceptance     
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab    
Where cover.CNO = acceptance.CNO       
 And cover.PHolder = Profile.ID                         
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 union            
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,                  
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance     
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO              
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                           
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                  
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)

GO

DROP FUNCTION ListQry_3b_a
GO
Create function ListQry_3b_a (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 [q].[COVERNO],    
 [q].[Insured],    
 [q].[CNO],    
 [q].[CStatus],    
 [q].[lANO],    
 [q].[ANO],    
 [q].[REGNO],    
 [q].[ADATE],    
 [q].[USERID],    
 [q].[Currency],     
 [q].[ASTATUS],    
 [q].[ATYPE],    
 [q].[SDate],    
 [q].[EDate],    
 [q].RYear,    
 [q].[ISType],    
 [q].[Renewal],    
 [q].[ESeqNo],    
 [q].[PolicyNo],    
 [q].[CertificateNo],    
 [q].[RefNo],    
 [q].[ProformaF],    
 a.valueid1, a.valuedesc1,    
 a.valueid2, a.valuedesc2,    
 a.valueid3, a.valuedesc3,    
 a.valueid4, a.valuedesc4,    
 a.valueid5, a.valuedesc5,    
 a.valueid6, a.valuedesc6,    
 a.valueid7, a.valuedesc7,    
 a.valueid8, a.valuedesc8,    
 a.valueid9, a.valuedesc9,    
 a.valueid10, a.valuedesc10,    
 a.valueid11, a.valuedesc11,    
 a.valueid12, a.valuedesc12,    
 a.valueid13, a.valuedesc13,    
 a.valueid14, a.valuedesc14,    
 a.VALUEID15 , a.VALUEDESC15    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) as q, ainfo as a    
Where [q].[ANO] = [a].[ANO]    
        
)    



go


--perbaikan interest info tidak bisa diklik
drop procedure [dbo].[PI04]
go
CREATE procedure [dbo].[PI04] (@P_ANO as integer)  
as  
Select I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)) as Remark, I1.Currency, Max(I1.SI) as SI, Max(I1.Total) as Aggregate, sum(I2.SI) as Declared, sum(I2.Indemnity) as Indemnity
from ICover I1 Left Join Acceptance A2 on (A2.LANO=I1.ANO and A2.AStatus='I') Left Join ICover I2 on (I2.ANO=A2.ANO and I2.Category='M' and I2.Currency=I1.Currency and I2.TOI=I1.TOI)  
Where I1.ANO=@P_ANO  
Group By I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)), I1.Currency  
Order By I1.Category Desc, I1.INO  
go
--Update Script - 21 July 2017 (1)--
DROP function ListQry_3
GO
CREATE function ListQry_3 (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,              
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab  
WHERE  Cover.CNO=Acceptance.CNO     
 and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.toc like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,   
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab  
Where cover.CNO = acceptance.CNO     
 And cover.PHolder = Profile.ID              
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union        
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)              
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO)   
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO        
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID               
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   
GO
DROP function ListQry_3_A
GO
Create function ListQry_3_A (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)      
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Q.[COVERNO],      
 Q.[Insured],      
 Q.[CNO],      
 Q.[CStatus],      
 Q.[lANO],      
 Q.[ANO],      
 Q.[REGNO],      
 Q.[ADATE],      
 Q.[USERID],      
 Q.[Currency],       
 Q.[ASTATUS],      
 Q.[ATYPE],      
 Q.[SDate],      
 Q.[EDate],      
 Q.RYear,      
 Q.[ISType],      
 Q.[Renewal],      
 Q.[ESeqNo],      
 Q.[PolicyNo],      
 Q.[CertificateNo],      
 Q.RefNo,      
 Q.ProformaF,      
 A.FLDID1,      
 A.VALUEID1,      
 A.VALUEDESC1,      
 A.FLDID2,      
 A.VALUEID2,      
 A.VALUEDESC2,      
 A.FLDID3,      
 A.VALUEID3,      
 A.VALUEDESC3,      
 A.FLDID4,      
 A.VALUEID4,      
 A.VALUEDESC4,      
 A.FLDID5,      
 A.VALUEID5,      
 A.VALUEDESC5,      
 A.FLDID6,      
 A.VALUEID6,      
 A.VALUEDESC6,      
 A.FLDID7,      
 A.VALUEID7,      
 A.VALUEDESC7,      
 A.FLDID8,      
 A.VALUEID8,      
 A.VALUEDESC8,      
 A.FLDID9,      
 A.VALUEID9,      
 A.VALUEDESC9,      
 A.FLDID10,      
 A.VALUEID10,      
 A.VALUEDESC10,      
 A.FLDID11,      
 A.VALUEID11,      
 A.VALUEDESC11,      
 A.FLDID12,      
 A.VALUEID12,      
 A.VALUEDESC12,      
 A.FLDID13,      
 A.VALUEID13,      
 A.VALUEDESC13,      
 A.FLDID14,      
 A.VALUEID14,      
 A.VALUEDESC14,      
 A.FLDID15,      
 A.VALUEID15,      
 a.VALUEDESC15      
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) AS Q, AINFO AS A      
Where q.ano_info = a.ANO      
)      

GO

DROP function ListQry_3b
GO
CREATE function ListQry_3b (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as varchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Cover, Acceptance     
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab    
Where cover.CNO = acceptance.CNO       
 And cover.PHolder = Profile.ID                         
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 union            
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,                  
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance     
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO              
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                           
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                  
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)

GO

DROP FUNCTION ListQry_3b_a
GO
Create function ListQry_3b_a (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 [q].[COVERNO],    
 [q].[Insured],    
 [q].[CNO],    
 [q].[CStatus],    
 [q].[lANO],    
 [q].[ANO],    
 [q].[REGNO],    
 [q].[ADATE],    
 [q].[USERID],    
 [q].[Currency],     
 [q].[ASTATUS],    
 [q].[ATYPE],    
 [q].[SDate],    
 [q].[EDate],    
 [q].RYear,    
 [q].[ISType],    
 [q].[Renewal],    
 [q].[ESeqNo],    
 [q].[PolicyNo],    
 [q].[CertificateNo],    
 [q].[RefNo],    
 [q].[ProformaF],    
 a.valueid1, a.valuedesc1,    
 a.valueid2, a.valuedesc2,    
 a.valueid3, a.valuedesc3,    
 a.valueid4, a.valuedesc4,    
 a.valueid5, a.valuedesc5,    
 a.valueid6, a.valuedesc6,    
 a.valueid7, a.valuedesc7,    
 a.valueid8, a.valuedesc8,    
 a.valueid9, a.valuedesc9,    
 a.valueid10, a.valuedesc10,    
 a.valueid11, a.valuedesc11,    
 a.valueid12, a.valuedesc12,    
 a.valueid13, a.valuedesc13,    
 a.valueid14, a.valuedesc14,    
 a.VALUEID15 , a.VALUEDESC15    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) as q, ainfo as a    
Where [q].[ANO] = [a].[ANO]    
        
)    
GO


--Update Script - 23 August 2017--

/****** Object:  Table [dbo].[RELIGION]    Script Date: 8/4/2017 12:56:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RELIGION](
	[RELIGION] [varchar](10) NOT NULL,
 CONSTRAINT [I_RELIGION] PRIMARY KEY CLUSTERED 
(
	[RELIGION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO RELIGION 
SELECT 'MOSLEM' 
UNION ALL 
SELECT 'CHRISTIAN'
UNION ALL
SELECT 'CATHOLIC'
UNION ALL
SELECT 'BUDDHA'
UNION ALL
SELECT 'HINDHU'
UNION ALL
SELECT 'OTHERS'




go
--VERSIONING
insert into versioning
select '2017 V.2.7.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
