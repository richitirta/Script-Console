--29 Mar 2018

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
ALTER TABLE dbo.ICOVER ADD
	EML float(53) NULL,
	EML_OC float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Estimate Max Loss'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ICOVER', N'COLUMN', N'EML'
GO
DECLARE @v sql_variant 
SET @v = N'Estimate Max Loss in Original Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ICOVER', N'COLUMN', N'EML_OC'
GO
ALTER TABLE dbo.ICOVER SET (LOCK_ESCALATION = TABLE)
GO
UPDATE ICOVER SET EML=0 Where EML IS NULL
GO
UPDATE ICOVER SET EML_OC=0 Where EML_OC IS NULL
COMMIT

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
ALTER TABLE dbo.RARRHEADER ADD
	LOLBASED int NULL
GO
DECLARE @v sql_variant 
SET @v = N'Limit Of Liability Based On (0 : Default/Limit Liability, 1 : SI, 2 : EML)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RARRHEADER', N'COLUMN', N'LOLBASED'
GO
ALTER TABLE dbo.RARRHEADER SET (LOCK_ESCALATION = TABLE)
GO
UPDATE RARRHEADER SET LOLBASED=0 WHERE LOLBASED IS NULL
COMMIT

GO

ALTER TABLE RARRHEADER ADD LOLBASED	int NULL
GO

DROP Procedure Reinsurance_Limit_Liability
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
SELECT  
SUM(
CASE 
WHEN COALESCE(R.LOLBASED,0)=0 THEN ICOVER.AMOUNT*coalesce(ICALC.PCTLOSS,100)/100*PCALC.RATE
WHEN COALESCE(R.LOLBASED,0)=1 THEN ICOVER.SI*coalesce(ICALC.PCTLOSS,100)/100*PCALC.RATE
WHEN COALESCE(R.LOLBASED,0)=2 THEN ICOVER.EML*PCALC.RATE
ELSE 0 END
) AS AMOUNT, 
Case 
When Max(coalesce(ICALC.PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100=0 then Max(coalesce(ICALC.PML,100)) 
Else Max(coalesce(ICALC.PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100 
end as PML,
Max(coalesce(ICALC.PCTLOSS,100)) as PCTLOSS       
From ICOVER       
LEFT JOIN RARRHEADER R ON (R.ANO=ICOVER.ANO)
inner join PCALC On (PCalc.ANO=ICover.ANO and PCalc.Currency=ICover.Currency)       
Left Join       
(       
 Select ICalc.INO, Max(ICalc.CURRENCY) as Currency, Max(ICalc.PCTLOSS) as PCTLOSS, Max(RCover.PML) as PML, Max(RCover.PMLAMOUNT) as PMLAMOUNT
 from ICalc, RCover       
 Where RCover.Category='M' and RCover.ANO=ICalc.ANO and RCover.Code=ICalc.Code and RCover.SDate=ICalc.SDate and ICalc.ANO=@P_ANO and @P_RDate between ICalc.SDate and ICalc.EDate       
 and Exists (Select max(R.SDATE) from RCover R Where R.ANO=@P_ANO and R.Category='M' and R.Code=RCover.Code and @P_RDate between R.SDate and R.EDate having max(R.SDATE)=RCover.SDate)       
 Group By ICalc.INO  
) ICalc       
On (ICalc.INO=ICover.INO and ICalc.Currency=ICover.Currency)       
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       


go

--30 MAR 2018
/****** Object:  Table [dbo].[ICOVERPOL]    Script Date: 3/30/2018 2:32:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ICOVERPOL](
	[ANO] [int] NOT NULL,
	[CURRENCY] [varchar](5) NULL,
	[Amount] [float] NULL,
	[LUserID] [Varchar](5) NULL,
	[LDate] [SmallDateTime] NULL
 CONSTRAINT [I_ICoverPol] PRIMARY KEY NONCLUSTERED 
(
	[ANO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No. (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ICOVERPOL', @level2type=N'COLUMN',@level2name=N'ANO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Currency Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ICOVERPOL', @level2type=N'COLUMN',@level2name=N'CURRENCY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Amount Of Policy Limit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ICOVERPOL', @level2type=N'COLUMN',@level2name=N'Amount'
GO


DROP Procedure Drop_Acceptance_Link
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   
Delete from PNOTES Where ANO=@P_ANO   
Delete from ICOVERPOL Where ANO=@P_ANO   

GO

DROP Procedure QInterest_Data
GO
CREATE Procedure QInterest_Data(@P_INO integer)  
as  
SELECT  
I1.*,  
I2.FLDID1, I2.VALUEID1, I2.VALUEDESC1,  
I2.FLDID2, I2.VALUEID2, I2.VALUEDESC2,  
I2.FLDID3, I2.VALUEID3, I2.VALUEDESC3,  
I2.FLDID4, I2.VALUEID4, I2.VALUEDESC4,  
I2.FLDID5, I2.VALUEID5, I2.VALUEDESC5,  
I2.FLDID6, I2.VALUEID6, I2.VALUEDESC6,  
I2.FLDID7, I2.VALUEID7, I2.VALUEDESC7,  
I2.FLDID8, I2.VALUEID8, I2.VALUEDESC8,  
I2.FLDID9, I2.VALUEID9, I2.VALUEDESC9,  
I2.FLDID10, I2.VALUEID10, I2.VALUEDESC10,  
I2.FLDID11, I2.VALUEID11, I2.VALUEDESC11,  
I2.FLDID12, I2.VALUEID12, I2.VALUEDESC12,  
I2.FLDID13, I2.VALUEID13, I2.VALUEDESC13,  
I2.FLDID14, I2.VALUEID14, I2.VALUEDESC14,  
I2.FLDID15, I2.VALUEID15, I2.VALUEDESC15,  
I3.FLDVALUEF, I3.FLDVALUEL,  
I3.FLDTAG1, I3.FLDVALUE1, I3.FLDOP1,  
I3.FLDTAG2, I3.FLDVALUE2, I3.FLDOP2,  
I3.FLDTAG3, I3.FLDVALUE3, I3.FLDOP3,  
I3.FLDTAG4, I3.FLDVALUE4, I3.FLDOP4,  
I3.FLDTAG5, I3.FLDVALUE5, I3.FLDOP5,  
I3.FLDTAG6 , I3.FLDVALUE6, I3.FLDOP6,
I4.CURRENCY as CURRENCY_POL, I4.AMOUNT as AMOUNT_POL
FROM ICOVER I1 
Left Join IINFO I2 On (I2.INO=I1.INO) 
Left Join ICoverExt I3 ON (I3.INO=I1.INO)  
Left Join ICOVERPOL I4 on (I4.ANO=I1.ANO)
WHERE I1.INO=@P_INO  
        

GO

ALTER TABLE SYSUSER ADD CCODE VARCHAR(10)
GO

--6 apr 2018
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
	XApplyVSCGroupF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Apply Virtual Account Xclude by List of Sub Company Group (0 : No, 1: Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccount', N'COLUMN', N'XApplyVSCGroupF'
GO
GO
ALTER TABLE dbo.VAccount SET (LOCK_ESCALATION = TABLE)
Update VAccount set XApplyVSCGroupF=0 Where XApplyVSCGroupF is null
GO
COMMIT


--10 APR 2018
DROP Procedure QCLAIMFACOUT
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,        

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,        

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100)

 Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 

(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 
0 END) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, 
Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Estimate,     

Case When RArrDet.Excess<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess else 0 end  
 else CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)  
end *(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100 as Claim,      

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
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
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
AND RArrDet.Status='A'     

GO                            

DROP Procedure QFACOUT
GO
CREATE Procedure QFACOUT(@P_ANO integer)      
as      
SELECT RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, RArrDet.Prorata, Profile.Name,     
FPart.SlipNo, FPart.SlipRetF, FPart.ID, FPart.Share AS RShare, FPart.Comm, FPart.WPC,      
FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.FullCoverF, RArrDet.OriginalF, RArrDet.PrecedeFacCessionF, FPart.Remarks,
FPart.Grace, FPart.Installment, RArrDet.AcceptedBy, RArrDet.AcceptedDate 
From RArrDet, FPart, Profile      
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID;      

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
R.SysUserID,         
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
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
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   

GO
DROP Function get_FacCoinsuranceShare
GO
CREATE Function get_FacCoinsuranceShare(@P_CNO integer)          
RETURNS Float AS        
  
BEGIN       
Declare @Share as Float
Select @Share=sum(Share)
from
(
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end) as Share
	From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
	WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
	AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
	AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')          
                          
	Union All                    
                          
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share
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
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')
) R

Return @Share
End

GO


Update R1 Set 
FShare=R2.FShare,
FAmount=R2.FShare/100*R1.TAmount,
Retention=100-(QAmount+QSRAmount)/TAmount*100-DShare-CShare-XPShare-Sp1Share-sp2share-sp3share-(AAMOUNT+AFRAmount)/TAmount*100-R2.FShare,
RAmount=(100-(QAmount+QSRAmount)/TAmount*100-DShare-CShare-XPShare-Sp1Share-sp2share-sp3share-(AAMOUNT+AFRAmount)/TAmount*100-R2.FShare)/100*R1.TAmount
from RArrHeader R1, 
(
Select A.ANO, sum((Case When R.Limit<>0 Then (R.Limit)/R2.TAmount*(R.Share-R.JPShare)/100 else (R.Share-R.JPShare)/100 end)*F.Share/100*100) as FShare
from FPart F, RArrDet R, Acceptance A, RArrheader R2 
Where R2.ANO=A.ANO and A.ANO=R.ANO and R.status='A' and F.ANO=R.ANO and F.FID=R.FID and R.Excess<>0
Group by A.ANO
) R2 
Where R2.ANO=R1.ANO
GO

--10 apr 2018
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
ALTER TABLE dbo.APDRuleH ADD
	PType varchar(10) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Profile Type (see Policy Holder Profile Type)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'PType'
GO
ALTER TABLE dbo.APDRuleH SET (LOCK_ESCALATION = TABLE)
GO
UPDATE APDRULEH SET PTYPE='<ALL>' WHERE PTYPE IS NULL
COMMIT
GO


Drop function Get_Policy_APRule
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
	Select Top 1 AH.RuleID
	from APDRuleH AH 
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
	and exists
	(  
		Select 1 
		from Acceptance A, Cover C, Profile P
		Where A.ANO=@P_ANO and C.CNO=A.CNO and P.ID=C.PHolder 
		and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType 
		and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
	)  
	Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)  
INNER JOIN ACCEPTANCE A ON (A.ANO=@P_ANO)
INNER JOIN COVER C ON (C.CNO=A.CNO)
WHERE charindex(A.AType,S.AccAType)<>0  and charindex(A.AStatus,S.AccAStatus)<>0  and charindex(C.CStatus,S.CoverCStatus)<>0  
)       
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
ALTER TABLE dbo.Segment ADD
	AutoInforceF bit NULL
GO
DECLARE @v sql_variant 
SET @v = N'Auto Inforce after auto Generate Renwal (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Segment', N'COLUMN', N'AutoInforceF'
GO
ALTER TABLE dbo.Segment SET (LOCK_ESCALATION = TABLE)
GO
Update Segment set AutoInforceF=0 Where AutoInforceF is null
COMMIT
GO


insert into sysprocess(MainProcName, ProcName, ProcGroup)
Select 'AutoGenerateRenewalPolicy_Process','AutoGenerateRenewalPolicy_Process','SC'


GO
DROP Procedure AutoGenerateRenewalPolicy_Process
GO
create Procedure AutoGenerateRenewalPolicy_Process(@P_PDate as smalldatetime)  
as
Select 
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end as ANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end as LANO, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end as PolicyNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end as CertificateNo,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end as SDate, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end as EDate,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end as Branch, 
Max(PolicyType.SType) as SType,
Max(Cover.CNO) as CNO, 
Max(Cast(Cover.OpenFlag as int)) as OpenFlag,
Max(Case When coalesce(RenewalRight.NewTOC,'')='' then Cover.TOC else RenewalRight.NewTOC end) as NewTOC,
cast(Max(cast(Segment.AutoInforceF as Int)) as Bit) as InforceF
from Acceptance 
inner join Cover on (Cover.CNO=Acceptance.CNO)
inner join Policytype on (PolicyType.PolicyType=Cover.PolicyType)
inner join TOC on (TOC.TOC=Cover.TOC and TOC.RQDays<>0)
inner join Segment on (Segment.Segment=Cover.Segment and Segment.AutoGenerateRenewalF=1)
Left Join Acceptance MAcceptance on (MAcceptance.ANO=Acceptance.LANO and Acceptance.LANO<>-1)
inner join Renewal on (Renewal.ANO=Acceptance.ANO and Renewal.Status='O' and ((Renewal.RenewalF=1 and Renewal.Action=0) or (Renewal.Action in (1,2))))
Left Join RenewalRight on (RenewalRight.TOC=Renewal.TOC and RenewalRight.RCode=Renewal.RCode)
Where Acceptance.ANO<>Acceptance.LANO and Acceptance.RenewableF=1 and Acceptance.AStatus in ('I','C') and Cover.CStatus<>'C'     
and Acceptance.EDate Between @P_PDate and dateadd(day,TOC.RQDays,@P_PDate)  
and Renewal.ASource='UW'
Group By
Renewal.ASource,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.ANO else MAcceptance.ANO end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.LANO else MAcceptance.LANO end, 
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.PolicyNo else MAcceptance.PolicyNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.CertificateNo else MAcceptance.CertificateNo end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.SDate else MAcceptance.EDate end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Renewal.EDate else dateadd(month,datediff(Month,MAcceptance.SDate, MAcceptance.EDate),MAcceptance.EDate) end,
Case When Acceptance.LANO=-1 or Cover.OpenFlag=1 Then Acceptance.Branch else MAcceptance.Branch end

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
ALTER TABLE dbo.SL_RequestRef ADD
	DocRefNo varchar(50) NULL,
	RefStatus varchar(20) NULL
GO
ALTER TABLE dbo.SL_RequestRef SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--13 apr 2018
DROP procedure PI04 
GO
CREATE procedure PI04 (@P_ANO as integer)  
as  
Select I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)) as Remark, I1.Currency, Max(I1.SI) as SI, Max(I1.SI) as Liability, Max(I1.Total) as Aggregate, Max(I1.Indemnity) as Indemnity
from ICover I1 
Where I1.ANO=@P_ANO  
Group By I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)), I1.Currency  
Order By I1.Category Desc, I1.INO  

go


DROP Procedure QCheckMaxOutGo
GO
CREATE Procedure [dbo].[QCheckMaxOutGo](@P_ANO as integer)   
as   
Declare @Temp Table(ANO Int, Code varchar(10), PrevOutGo Float, OutGo Float)   
insert into @Temp(ANO, Code, PrevOutGo, OutGo)   
Select Distinct R1.ANO, R1.Code, dbo.Premium_MaxOutGo(A.PANO, R1.Code,0) as PrevOutGo, dbo.Premium_MaxOutGo(A.ANO, R1.Code,0) as OutGo from Acceptance A, RCover R1 Where R1.ANO=A.ANO and A.ANO=@P_ANO   
Select R1.ANO,   
Case   
When R1.OutGo>R2.MaxOutGo Then 'Rate Code ('+R1.Code+') Maximum Out Go !'   
When R1.OutGo>BS.MaxOutGo Then 'Business Source ('+BS.ID+') Maximum Out Go !'   
When R1.OutGo>BR.MaxOutGo Then 'Business Rule ('+BR.BizMapID+') Maximum Out Go !'   
End as ErrDesc   
from @Temp R1  
Inner Join Acceptance A on (A.ANO=R1.ANO)  
Inner Join RArrHeader R on (R.ANO=A.ANO)   
Inner Join Cover C on (C.CNO=A.CNO)   
Inner join Profile BS on (BS.ID=A.Source)   
Inner join RateTab R2 on (R2.Code=R1.Code)   
Left Join BRRule BR on (BR.TOC=A.TOC and (BR.Branch='<All>' or BR.Branch=A.Branch) and (BR.BizmapID='<All>' or BR.BizMapID=A.BizMapID) and (BR.FacOpt=0 or (BR.FacOpt=1 and R.FAmount<>0) or (BR.FacOpt=2 and R.FAmount=0)))   
Where R1.PrevOutGo<R1.OutGo   
and ((R2.MaxOutGo<>0 and R1.OutGo>R2.MaxOutGo+0.0000000001) Or (BS.MaxOutGo<>0 and R1.OutGo>BS.MaxOutGo+0.0000000001) Or (BR.MaxOutGo<>0 and R1.OutGo>BR.MaxOutGo+0.0000000001))

go

UPDATE ACCEPTANCE SET BATCHNO='' WHERE BATCHNO IS NULL
go

drop function FL_SR_TOC
go
create function FL_SR_TOC(@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct TOC.TOC,TOC.Description,  TOC.NOINPUTF
From TOC, PTClass, SysUserTOC S 
Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and (PTCLASS.TOC='<All>' or PTCLASS.TOC=TOC.TOC) and TOC.TOC like @P_TOC+'%' 
and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)
and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)
)

go

drop function dbo.getRatePremi
go
CREATE function dbo.getRatePremi(@ano as int,@recno as int,@flag as int)              
returns float as              
begin              
declare @result as float              
declare @rate as float              
declare @counter as int              
set @result=0              
set @counter=1              
if @flag =1              
 begin              
 declare csr cursor for select rate from rcover where ano=@ano              
 end              
else              
 begin              
 if @flag=2         
  begin        
  declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='P'              
  end        
 else        
  begin        
  if @flag=3        
   begin        
   declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='O'              
   end    
 else        
  begin        
  if @flag=4        
   begin        
   declare csr cursor for select Amount from accass where ano=@ano and type='DI' and code='P'              
   end       
   else    
   begin      
  if @flag=5       
   begin        
   declare csr cursor for select Amount from accass where ano=@ano and type='DI' and code='O'              
   end     
  else        
     begin        
     declare csr cursor for select CAmount from accass where ano=@ano and type='DI' and code='F'              
     end        
  end        
 end        
 end   
 end  
open csr              
          
fetch next from csr into @rate     
 while @@fetch_status=0       
  begin            
  if @counter=@recno    
   begin          
    set @result=@rate     
    break;       
   end             
  set @counter=@counter+1    
  fetch next from csr into @rate   
  end              
close csr    
deallocate csr     
return @result      
end

go



insert into SysForm(FName, Description, FCode)
Select 'FORCEFILLCCONDITION','Force Fill Claim Condition','ACTIVITIES'
go

insert into SysForm(FName, Description, FCode)
Select 'FORCECHECKCLAIMREFNO','Force Check Duplicate Claim Reference No ','ACTIVITIES'
go
insert into SysForm(FName, Description, FCode)
Select 'FORCECHECKCLAIMCNC','Force Check Certificate No of Claim ','ACTIVITIES'
go

insert into SysForm(FName, Description, FCode)
Select 'CNOTESFRM','Claim Notes','CLAIM'
go

insert into SysForm(FName, Description, FCode)
Select 'CNOTESDLG','Claim Notes Dialog','CLAIM'
go

insert into SysForm(FName, Description, FCode)
Select 'CLSCREENINGDLG','Claim Screening Dialog','CLAIM'
go


Create Unique Index I_SysUserVType on sysuservtype(ID, VType)
go

DROP PROCEDURE CLVIEW06B 
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE
FROM RARRHEADER R, CARRHEADER C, CLAIM, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CLAIM.CNO=@P_CNO and C.CNO=CLAIM.CNO and R.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=R.ANO 


go


DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_DocNO varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)*100
from nVoucher V 
Where Exists (Select Voucher from Admlink A Where V.Voucher=A.Voucher and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.DocNo<=@P_DocNo and A.SUbject='Premium' and V.DebtorF=1 and A.Type in ('DI','IC','IR'))
Having sum(case When V.DebtorF=1 Then (V.Nominal_CC-V.Diff_CC) Else -(V.Nominal_CC-V.Diff_CC) end)<>0

if @PCT IS NULL 
	SELECT @PCT=100

Return @PCT
End


GO

--25 APRL 2018

insert into sysform(FName, Description, FCode)
Select 'FORCELICENSEEXPIRY','FORCE CHECK BUSINESS SOURCE LICENSE EXPIRY','ACTIVITIES'

GO

DROP FUNCTION FN_UserBusinessSource 
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10))      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
and coalesce(P.LicenseExpiry,cast(convert(varchar(10), getdate(),1) as smalldatetime))>=cast(convert(varchar(10), getdate(),1) as smalldatetime)
Where @P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or NOT EXISTS (Select PID from SysUserAssignment S Where S.PID=P.ID and S.AssType='SOURCE' and S.ID<>@P_UserID)
)    
GO

--26 apr 2018
drop index SL_Request.I_SL_Request_Request_DocNo_SortNo
go
drop index SL_Request.I_SL_Request_Request_Doc_No_SortNo

go

--VERSIONING
insert into versioning
select '2018 V.1.6.0',GETDATE(),'2018 V.1.6.0',GETDATE(),'K: 2018 V.1.6.0',GETDATE()
go
