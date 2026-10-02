--force fill condition
insert into SysForm(FName, Description, FCode)
Select 'FORCEFILLCCONDITION','Force Fill Claim Condition','ACTIVITIES'
go

--inisialisasi proforma policy
select top 1 * into #prof from PolicyType

--select * from #prof

update #prof set PolicyType='', Description='Proforma Policy', Last_Update=GETDATE()
go

insert into policytype select * from #prof
go


--Perubahan Length
ALTER TABLE [dbo].inparty alter column ID_NO varchar(30) not null
GO

-- bugs tidak bisa closing
DROP FUNCTION fn_Exchange
GO
CREATE FUNCTION fn_Exchange(@PDate as smalldatetime) 
RETURNS @EXCHANGE TABLE (Currency varchar(10), Effective smalldatetime, Rate float, TRate Float, BIRate Float, RRate Float, VRate Float, Rate_RC Float, VRate_RC Float) 
AS 
BEGIN 
insert into @EXCHANGE 
Select Currency.Currency, Currency.Effective, Currency.Rate, Currency.TRate, Currency.BIRate, Currency.RRate, Currency.VRate, Currency.Rate_RC, Currency.VRate_RC 
from Currency, SysTab 
Where Currency.Currency<>SysTab.Currency and Currency.Effective<=@PDate 
 
insert into @EXCHANGE 
Select E1.Currency, E1.Effective, E1.Rate, E1.TRate, E1.BIRate, E1.RRate, E1.VRate, E1.Rate_RC, E1.VRate_RC 
from Exchange E1, Currency
Where Currency.Currency=E1.Currency and E1.Effective<=@PDate and Currency.Effective>@PDate 
and E1.Effective=coalesce((Select Top 1 E2.Effective from Exchange E2 Where E2.Currency=E1.Currency and E2.Effective<=@PDate Order By E2.Effective Desc),'01/01/1900') 
 
insert into @EXCHANGE 
Select Currency, @PDate as Effective, 1 as Rate, 1 as TRate, 1 as BIRate, 1 as RRate, 1 as VRate, 1 as Rate_RC, 1 as VRate_RC
from Currency 
Where NOT EXISTS (Select Currency from @Exchange E Where E.Currency=Currency.Currency) 
 
RETURN 
END 
 
GO

--Bugs object info tidak bisa > 15 kar

 Drop procedure [dbo].[QSpreadInfo_Default] 
 go
Create procedure [dbo].[QSpreadInfo_Default] (@FLDID as varchar(10), @VALUEID as varchar(max))
as
select top 1 * from (
Select top 1 * from GenDTab Where FLDID=@FLDID and ValueID=@ValueID
union all
Select top 1 @FLDID as [FLDID],'' as [VALUEID], cast(@ValueID as varchar(max)) as description,'' as [NEWVALUEID],'' as [NEWVALUEDESC],1 as [ALLOWEDF] ,d.[FORMULA]
      ,d.[FLOWER],d.[FUPPER],d.[SFLDID],d.[SVALUEID],d.[FLDID1],'' as[VALUEID1],'' as[VALUEDESC1],d.[FLDID2],'' as[VALUEID2]
      ,'' as[VALUEDESC2],d.[FLDID3],'' as[VALUEID3],'' as[VALUEDESC3],d.[FLDID4],'' as[VALUEID4],'' as[VALUEDESC4],d.[FLDID5]
      ,'' as [VALUEID5],'' as [VALUEDESC5],d.[FLDID6],'' as [VALUEID6],'' as[VALUEDESC6],d.[FLDID7],'' as[VALUEID7],'' as[VALUEDESC7]
      ,d.[FLDID8],'' as[VALUEID8],'' as[VALUEDESC8],d.[FLDID9],'' as[VALUEID9],'' as[VALUEDESC9],d.[FLDID10],'' as[VALUEID10]
      ,'' as[VALUEDESC10],d.[FLDID11],'' as[VALUEID11],'' as[VALUEDESC11],d.[FLDID12],'' as[VALUEID12],'' as[VALUEDESC12],d.[FLDID13]
      ,'' as[VALUEID13],'' as[VALUEDESC13],d.[FLDID14],'' as[VALUEID14],'' as[VALUEDESC14],d.[FLDID15],'' as[VALUEID15],'' as[VALUEDESC15]
      ,d.[Last_Opr],d.[Last_Update],d.[ICPSF],d.[B2BF],d.[FLDCHGINF] 
from GENDTAB d, genhtab h
where d.fldid=h.FLDID and d.FLDID=@FLDID
union all
Select top 1 @FLDID as [FLDID],'' as [VALUEID], cast(@ValueID as varchar(max)) as description,'' as [NEWVALUEID],'' as [NEWVALUEDESC],1 as [ALLOWEDF] ,d.[FORMULA]
      ,d.[FLOWER],d.[FUPPER],d.[SFLDID],d.[SVALUEID],d.[FLDID1],'' as[VALUEID1],'' as[VALUEDESC1],d.[FLDID2],'' as[VALUEID2]
      ,'' as[VALUEDESC2],d.[FLDID3],'' as[VALUEID3],'' as[VALUEDESC3],d.[FLDID4],'' as[VALUEID4],'' as[VALUEDESC4],d.[FLDID5]
      ,'' as [VALUEID5],'' as [VALUEDESC5],d.[FLDID6],'' as [VALUEID6],'' as[VALUEDESC6],d.[FLDID7],'' as[VALUEID7],'' as[VALUEDESC7]
      ,d.[FLDID8],'' as[VALUEID8],'' as[VALUEDESC8],d.[FLDID9],'' as[VALUEID9],'' as[VALUEDESC9],d.[FLDID10],'' as[VALUEID10]
      ,'' as[VALUEDESC10],d.[FLDID11],'' as[VALUEID11],'' as[VALUEDESC11],d.[FLDID12],'' as[VALUEID12],'' as[VALUEDESC12],d.[FLDID13]
      ,'' as[VALUEID13],'' as[VALUEDESC13],d.[FLDID14],'' as[VALUEID14],'' as[VALUEDESC14],d.[FLDID15],'' as[VALUEID15],'' as[VALUEDESC15]
      ,d.[Last_Opr],d.[Last_Update],d.[ICPSF],d.[B2BF],d.[FLDCHGINF] 
from GENDTAB d) T
go

--2 mar 2018
--INSURANCE SOURCE (ISDLG) - LOOK UP F2 PADA DETAIL RISK

DROP FUNCTION FL_TOR2
GO
CREATE FUNCTION FL_TOR2(@PCNO as integer)       
RETURNS Table       
AS RETURN (       
SELECT Distinct Rcover.CODE, RateTab.Description
From acceptance, RCOVER, RateTab
WHERE Acceptance.CNO=@PCNO and RCover.ANO=Acceptance.ANO and RateTab.Code=RCover.Code
)       

GO

DROP PROCEDURE QTOR_2 
GO
CREATE PROCEDURE QTOR_2 (@pCNO as integer)
AS
SELECT Distinct Rcover.CODE, RateTab.Description
From acceptance, RCOVER, RateTab
WHERE Acceptance.CNO=@PCNO and RCover.ANO=Acceptance.ANO and RateTab.Code=RCover.Code
go

--PENAMBAHAN SEQUENCE NO DI INPARTY
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
ALTER TABLE dbo.INPARTY ADD
	IPNO int NOT NULL IDENTITY (1, 1)
GO
DECLARE @v sql_variant 
SET @v = N'Record No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'INPARTY', N'COLUMN', N'IPNO'
GO
ALTER TABLE dbo.INPARTY SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO



--4 mar 2018
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
	Estimate float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Accumulated Claim Esimate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ICOVER', N'COLUMN', N'Estimate'
GO
ALTER TABLE dbo.ICOVER SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ICOVERNOC ADD
	Estimate float(53) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Accumulated Claim Esimate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ICOVERNOC', N'COLUMN', N'Estimate'
GO
ALTER TABLE dbo.ICOVERNOC SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO

DROP Function FL_CL_TOI
GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT        
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE        
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, ACCEPTANCE        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI                
)   

GO
DROP Function FL_CL_NOC 
GO
Create Function FL_CL_NOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), CTLF bit, Currency varchar(5), Amount_1 Float, Amount_2 Float, limit Float, Indemnity Float, Estimate Float)      
AS      
BEGIN          
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)      
    
if @P_Value is null     
 Select @P_Value=0    
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
ICOVERNOC.LIMIT, ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE    
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                                                
 0 as Limit,                  
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      

GO

DROP PROCEDURE QCLACC01 

GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT        
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE        
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, ACCEPTANCE        
WHERE CLAIM.CNO=@PCNO AND (@PINO=0 or ICOVER.INO=@PINO) AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI        

GO

DROP PROCEDURE QCLNOC
GO
CREATE PROCEDURE QCLNOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))                        
AS                        
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)    
if @P_Value is null     
 Select @P_Value=0    
                      
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, 
ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
ICOVERNOC.LIMIT, ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                           
 0 as Limit,                  
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          

go


--perubahan karena akumulasi dihitung berdasarkan Booking Rate
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

 Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
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


alter table icover 
alter column remark varchar(max)
go


--Perubahan Length
ALTER TABLE [dbo].[ID_TYPE] DROP CONSTRAINT [I_ID_TYPE]
GO
alter table id_type alter column id_type varchar(50) not null
go

alter table profile_ext alter column id_type varchar(50)
go
ALTER TABLE [dbo].[ID_TYPE] ADD  CONSTRAINT [I_ID_TYPE] PRIMARY KEY CLUSTERED 
(
	[ID_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--VERSIONING
insert into versioning
select '2018 V.1.4.0',GETDATE(),'2018 V.1.4.0',GETDATE(),'K: 2018 V.1.4.0',GETDATE()
go
