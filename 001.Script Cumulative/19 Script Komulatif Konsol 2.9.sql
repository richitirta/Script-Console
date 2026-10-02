Delete from Hint


Insert into Hint(Hint, ShortDesc, Remarks, ShortDesc_1, Remarks_1)
Select -1,'Premium','Premium','--Un-Used--','--Un-Used--'
Union all
Select -2,'Commission','Commission','--Un-Used--','--Un-Used--'
Union all
Select -3,'Fee','Fee','--Un-Used--','--Un-Used--'
Union all
Select -4,'Stamp Duty/G.Fund','Stamp Duty/Guarantee Fund','--Un-Used--','--Un-Used--'
Union all
Select -5,'Disc. (Over.)','Discount/Overriding','--Un-Used--','--Un-Used--'
Union all
Select -6,'--Un-Used--','--Un-Used--','Claim Amount','Claim Amount'
Union all
Select -7,'--Un-Used--','--Un-Used--','Deductible','Deductible Amount'
Union all
Select -8,'--Un-Used--','--Un-Used--','Salvage Amount','Salvage'
Union all
Select -9,'--Un-Used--','--Un-Used--','Claim Expenses','Claim Expenses'
Union all
Select -10,'--Un-Used--','--Un-Used--','Subrogation','Subrogation Amount'
Union all
Select -11,'Other Income','Other Income (Premium)','--Un-Used--','--Un-Used--'
Union all
Select -12,'--Un-Used--','--Un-Used--','Other Income','Other Income (Claim)'
Union all
Select -13,'PPN (VAT)','Pajak Pertambahan Nilai','PPN (VAT)','Pajak Pertambahan Nilai'
Union all
Select -14,'PPH (TAX)','Pajak Penghasilan','PPH (TAX)','Pajak Penghasilan'
Union all
Select -15,'Others Fee','Others Fee','Others Fee','Others Fee'
Union all
Select -16,'Others Stamp Duty #1','Others Stamp Duty #1','Claim Stamp Duty','Claim Stamp Duty'
Union all
Select -17,'Others Stamp Duty #2','Others Stamp Duty #2','Claim Adjustment','Claim Adjustment'
Union all
Select -18,'Claim Reserve','Claim Reserve','--Un-Used--','--Un-Used--'
Union all
Select -19,'Deposit','Deposit/Premium Reserve','--Un-Used--','--Un-Used--'
Union all
Select -20,'Ujroh Cedant','Ujroh Cedant','--Un-Used--','--Un-Used--'
go
Update Hint Set Last_Opr='CARE', Last_Update='12/31/2016'
go

Select * from Hint
go


-- 25 agst 2017  : PENAMBAHAN % LOSS PADA ENTRY LOSS ITEM
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EDepreciation' AND Object_ID = Object_ID(N'CLItem'))
BEGIN
ALTER TABLE CLItem ADD EDepreciation float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Depreciation' AND Object_ID = Object_ID(N'CLItem'))
BEGIN
ALTER TABLE CLItem ADD Depreciation float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTLoss' AND Object_ID = Object_ID(N'CLItem'))
BEGIN
ALTER TABLE CLItem ADD PCTLoss float(53) NULL

DECLARE @v sql_variant 
SET @v = N'% Percentage Loss Indemnity (100% Less % Depreciation)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLItem', N'COLUMN', N'PCTLoss'

END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EDepreciation' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD EDepreciation float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Depreciation' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD Depreciation float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Depreciation Amount (Calculated from Loss Payment Percentage in CLITEM)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'Depreciation'
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCALC01a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION CCALC01a END   
GO

CREATE FUNCTION CCALC01a(@P_CNO as integer)            
RETURNS Table            
AS RETURN (            
SELECT CLLOSS.CURRENCY, Max(RCOVER.CODE) as Code, max(ICALC.TOR) as TOR,            
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.ESTIMATE)
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.ESTIMATE) 
  END    
 ) as LOSS,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
  END    
 ) as INDEMNITY,            
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.ESTIMATE            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.ESTIMATE            
  END*(RCOVER.COSHARE)/100    
 ) +
 Max(    
  CASE            
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.EDEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.EDEPRECIATION
  END
 ) 
 as EDEDUCTIBLE,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.AMOUNT            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.AMOUNT            
  END*(RCOVER.COSHARE)/100    
 ) +
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
  END
 ) 
 as DEDUCTIBLE,            
 0 as ESALVAGE, 0 AS SALVAGE
From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, cover, COL    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLLOSS.CNO 
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLLOSS.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.PAYMENT, CLLOSS.NOC, CLLOSS.Currency, CLLOSS.RefNo  
    
Union All            
                      
SELECT CLDED.CURRENCY, Max(RCOVER.CODE) as Code, max(RCALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, Max(CLDED.ESTAMOUNT) AS EDEDUCTIBLE, Max(CLDED.AMOUNT) AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE            
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
    
                      
Union All            
                      
SELECT CLSAL.CURRENCY, Max(RCOVER.CODE) as Code, Max(ICALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, MAX(CLSAL.EAMOUNT) AS ESALVAGE, Max(CLSAL.AMOUNT) AS SALVAGE
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
)            

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLItemLossTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP PROCEDURE CLItemLossTo END 
GO

CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CLLOSS.CNO, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo,  
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
  END    
 ) as CLAIM,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.TAX)             
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.TAX)             
  END    
 ) as TAX,            
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.AMOUNT            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.AMOUNT            
  END*(RCOVER.COSHARE)/100    
 ) +
 Max(    
  CASE            
   WHEN CLLOSS.STATUS<>'P' THEN 0
   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
  END
 ) 
 as DEDUCTIBLE
From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, cover, COL    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLLOSS.CNO 
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLLOSS.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLLOSS.CNO, CLLOSS.PAYMENT, CLLOSS.Currency, CLLOSS.RefNo  
GO

--24 agst 2017 (1) : 

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ComAcc_Cheque') AND type in (N'U'))
BEGIN

CREATE TABLE ComAcc_Cheque(
	ComAcc varchar(30) NOT NULL,
	ChequeNo varchar(50) NOT NULL,
	Voucher varchar(20) NOT NULL,
	Last_Opr varchar(50) NOT NULL,
	Last_Update smalldatetime,
 CONSTRAINT I_ComAcc_Cheque PRIMARY KEY CLUSTERED 
(
	ComAcc ASC,
	ChequeNo ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE ComAcc_Cheque  WITH NOCHECK ADD  CONSTRAINT FK_ComAcc_Cheque_ComAcc FOREIGN KEY(ComAcc)
REFERENCES ComAcc (ComAcc)
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE ComAcc_Cheque CHECK CONSTRAINT FK_ComAcc_Cheque_ComAcc
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Account ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ComAcc_Cheque', @level2type=N'COLUMN',@level2name=N'ComAcc'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cheque No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ComAcc_Cheque', @level2type=N'COLUMN',@level2name=N'ChequeNo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Payment Voucher No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ComAcc_Cheque', @level2type=N'COLUMN',@level2name=N'Voucher'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ChequeSeqNo' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE ComAcc ADD ChequeSeqNo int NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ChequeFormat' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE ComAcc ADD ChequeFormat varchar(150) NULL
END
GO


--TaxType pada Profile mengacu pada Table Tax Type

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TAXRATE' AND Object_ID = Object_ID(N'TAXTYPE'))
BEGIN
ALTER TABLE TAXTYPE ADD TAXRATE nchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DESCRIPTION' AND Object_ID = Object_ID(N'TAXTYPE'))
BEGIN
ALTER TABLE TAXTYPE ADD	DESCRIPTION varchar(255) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOWER' AND Object_ID = Object_ID(N'TAXTYPE'))
BEGIN
ALTER TABLE TAXTYPE ADD	LOWER float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UPPER' AND Object_ID = Object_ID(N'TAXTYPE'))
BEGIN
ALTER TABLE TAXTYPE ADD	UPPER float(53) NULL
END
GO


--Pada Table ADMLINK ditambahkan dua(2) kolom yakni PNOMINAL_VAT dan PNOMINAL_TAX, yang beriisikan nilai Nominal yang didasarkan untuk perhitungan VAT atau perhitungan TAX (ketimbang dengan mengambil AMOUNT_1+AMOUNT_2…..) dan juga sebagai historis dasar perhitungan yang digunakan

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PNominal_Vat' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	PNominal_Vat float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PNominal_Tax' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	PNominal_Tax float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Nominal for Tax Calculation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'PNominal_Tax'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOR' AND Object_ID = Object_ID(N'RATETAB'))
BEGIN
ALTER TABLE RATETAB ADD TOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Main Type Of Risk Where The Additional Rate Code is related'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATETAB', N'COLUMN', N'TOR'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QMissing_Risk') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP procedure QMissing_Risk
END
GO
CREATE  procedure QMissing_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1 
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO 
and (R1.Category='A' or not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate)) 
and Not Exists
( 
Select Top 1 R2.ANO 
from RCover R2 
Where R2.Category='M' and R2.ANO=R1.ANO and not (R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
and 
( 
(R2.Sdate<=R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>=R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>=R2.Sdate) or (R1.Sdate<=R2.Edate and R1.Edate>=R2.Edate) 
) 
) 

Union All
 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1, RateTab R3
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO 
and R1.Category='A' and R3.Code=R1.Code and R3.TOR<>''
and Not Exists
(
Select Top 1 R2.ANO 
from RCover R2, RateTab R4, RateCOV R5
Where R2.Category='M' and R2.ANO=R1.ANO and R4.Code=R2.Code and R5.Code=R4.Code and R5.TOR=R3.TOR
and 
( 
(R2.Sdate<=R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>=R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>=R2.Sdate) or (R1.Sdate<=R2.Edate and R1.Edate>=R2.Edate) 
)
)
go



--VERSIONING
insert into versioning
select '2017 V.2.9.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='18 Script Komulatif Konsol 2.8'
Select @CurrSCript='19 Script Komulatif Konsol 2.9'


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

