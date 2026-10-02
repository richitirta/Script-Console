--Penambahan FLAG ANNUAL TREATY DI RISK ARRANGEMENT

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE View04  END 
GO

CREATE PROCEDURE View04(@P_ANO as integer)       
AS      
SELECT R.*, TOC.REGID, A.AnnualTreatyF, A.FLDID, A.ValueID, C.OpenFlag, A.TOC, A.PolicyNo, A.CertificateNo, A.RegNo, C.CoverNo, C.ISType, A.RANO, A.AType, A.AStatus, A.SDate, A.EDate, MA.SDate as M_SDate, MA.EDate as M_EDate
FROM Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Inner Join RArrHeader R on (R.ANO=A.ANO)
Left Join ACCEPTANCE MA on (MA.ANO=A.LANO)
WHERE A.ANO=@P_ANO 

GO



--19 okt 2018

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RUserID' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	RUserID varchar(50) NULL
end
go	

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RUserDate' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	RUserDate smalldatetime NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RUserTime' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	RUserTime varchar(8) NULL
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QClaim_Data  END 
GO

CREATE Procedure QClaim_Data(@P_CNO integer) 
as 
SELECT CNO, ANO, EVENTNO, CLAIMNO, REGDATE,REFNO,REFDATE,REFTIME, POLICYNO, CERTIFICATENO, CLAIMANT, CLAIMANTINFO, PAYMENT, TOC, COL, EVENTNAME, LOCATION, LOSSPLACE, LOSSDATE, LOSSTIME, DESCRIPTION, SURVEYOR, ASSESSOR, BRANCH, 
UserID, CDate, CTime, 
LUSERID, LDate, LTime, 
PUSERID, PUserDate, PUserTime, 
RUserID, RUserDate, RUserTime, 
AUSERID, AUserDate, AUserTime, 
CUserID, CloseDate, CloseTime, 
EXGRATIAF, TBAF_1, TBAF_2, (TBAF_1 | TBAF_2) as TBAF, CSTATUS, 
CType, PCSTATUS, VSEQNO, CSEQNO, ISTYPE, 
ASource, BackDatedF, SettledF, CT, SysUserID, Condition
FROM CLAIM C1 
WHERE C1.CNO=@P_CNO 
GO

--24 Okt 2018 : AutoeventNotification

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'AEBucket') AND type in (N'U'))
BEGIN
CREATE TABLE AEBucket(
	PID int IDENTITY(1,1) NOT NULL,
	AppID varchar(20) NOT NULL,
	AppType varchar(10) NOT NULL,
	Category varchar(3) NULL,
	ERule varchar(3) NULL,
	Status varchar(1) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
	PDate smalldatetime NULL,
	ErrMsg varchar(255) NULL,
 CONSTRAINT I_AEBucket PRIMARY KEY CLUSTERED 
(
	PID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Application ID / Document ID (see Acceptance No or Claim No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AEBucket', @level2type=N'COLUMN',@level2name=N'AppID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'App Type (''Policy'',''Claim'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AEBucket', @level2type=N'COLUMN',@level2name=N'AppType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Category Email Rule' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AEBucket', @level2type=N'COLUMN',@level2name=N'Category'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Rule' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AEBucket', @level2type=N'COLUMN',@level2name=N'ERule'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Auto Event Status (''R''equest, ''P''rocessed, ''C''losed/Cancelled)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AEBucket', @level2type=N'COLUMN',@level2name=N'Status'

END
GO




IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_AEBucket_APPID_APPTYPE_Category_ERule_Status' AND object_id = OBJECT_ID('AEBucket'))
BEGIN
Create index I_AEBucket_APPID_APPTYPE_Category_ERule_Status on AEBucket(APPID, APPTYPE, CATEGORY, ERULE, STATUS)
END
go

IF NOT EXISTS(SELECT * FROM SysProcess WHERE ProcName='AUTOEVENTNOTIFICATION_PROCESS')
BEGIN
insert into SysProcess(ProcName, ProcGroup, StartTime, EndTime, STartDay, EndDay, MainProcName)
Select 'AUTOEVENTNOTIFICATION_PROCESS','SC','00:00','24:00',1,31,'AUTOEVENTNOTIFICATION_PROCESS'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AUTOEVENTNOTIFICATION_PROCESS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE AUTOEVENTNOTIFICATION_PROCESS  END 
GO

CREATE Procedure AUTOEVENTNOTIFICATION_PROCESS(@P_PDate as smalldatetime)                                        
as                               
Select * 
from AEBucket with (ReadCommitted)
where Status='R' 


go

--PENAMBAHAN PREMIUM CALCULATION METHOD (PCALC) DI TOPRO VS SETTING CALC METHOD DI RATE CON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCALC' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD
	PCALC varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Premium Calc Method (''F''lat,''P''rorate), if Empty, Automatic by Application'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'PCALC'
END
GO


--25 OKT 2018
IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='PROFILE_LOB')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'PROFILE_LOB','Allow Change Profile LOB','ACTIVITIES'
END
GO

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWCHANGEPROFILEDOCQRY')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGEPROFILEDOCQRY','Allow Change Profile in Document Query','ACTIVITIES'
END
GO

--26 OKT 2018
IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER END
GO

CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION R_SL_ALLOCATED END
GO

CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate                     
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate              
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all                                     
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                               
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
                                       
)     

GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_PERIOD') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION R_SL_ALLOCATED_BY_PERIOD END
GO

CREATE FUNCTION R_SL_ALLOCATED_BY_PERIOD(@P_SDATE as SmallDatetime, @P_EDATE as SmallDatetime)                             
RETURNS TABLE  AS                               
RETURN (                             
--SL from Payment Voucher                                       
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date Between @P_SDate and @P_EDate               
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                             
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date Between @P_SDate and @P_EDate               
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date Between @P_SDate and @P_EDate                      
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                    
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date Between @P_SDate and @P_EDate               
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                           
       
union all                                       
                                  
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date Between @P_SDate and @P_EDate                                                                  
)       

GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_DETAIL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION R_SL_ALLOCATED_DETAIL END
GO

CREATE FUNCTION R_SL_ALLOCATED_DETAIL(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Voucher, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pVoucher.RefNo, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate                     
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate              
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all    
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
                                       
)     

GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION SL_ALLOCATED END
GO

CREATE FUNCTION SL_ALLOCATED()         
RETURNS TABLE  AS         
RETURN (         


--SL from Payment Voucher         
Select SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date as Doc_Date, Voucher.Currency as Doc_CCY, SL.Voucher as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate, sum(SL.Nominal) as Nominal_OC         
from pSL SL, pVoucher Voucher         
Where Voucher.SL_Cat in ('P') and SL.Voucher=Voucher.Voucher and SL.PaymentF=1         
Group By SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date, Voucher.Currency, SL.Account         

Union All         

--SL from Overbooking Payment and Adjustment Payment         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate,         
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern         
Where VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end                       

Union All         
                      
--SL from Adjustment Overbooking         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate, 
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern         
Where VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher 
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end      

Union All         

--SL from Sub Ledger Payment Voucher and OverPaid         

Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate,         
(Case When VoucherR.SL_Cat='O'         
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
end) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR         
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1         
)          


GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION OS_VOUCHER_P END
GO

CREATE function OS_VOUCHER_P (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
 FROM        
 (        
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
Union All        
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher) SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 


GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_SUSPEND') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION OS_SUSPEND END
GO

CREATE function OS_SUSPEND (@P_Voucher Varchar(20))                      
RETURNS Table                      
AS RETURN                      
(                      
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                      
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                      
PV.NOMINAL_CC AS NOMINAL,                      
PV.PAYMENT_CC AS PAYMENT,                      
PV.NOMINAL_CC-PV.PAYMENT_CC AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT
FROM pVoucher VOUCHER                      
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')                  
Inner JOIN             
(            
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            
 FROM            
 (            
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL WHERE (SL.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
 Union All            
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER(@P_VOUCHER) SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO AND (PVOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT            
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)            
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0 AND (VOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='')    
AND ROUND(PV.NOMINAL_CC-PV.PAYMENT_CC,4)<>0            
)   

GO

IF EXISTS  (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oSL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION oSL END
GO


CREATE Function oSL(@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case 
When VType.Code<>'MATCHING' and pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0 then
       Case When exists(Select Top 1 R.PID from RPBucket R Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>'' and R.Status<>'C') Then cast(1 as Bit) else cast(0 as Bit) end
else
       (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)
end
as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF
From pVoucher 
Inner Join dbo.VType on (VType.VType=pVoucher.VType)
Inner Join pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 

go

--Update Customized Report
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='LinkAttr' AND CONSTRAINT_NAME='I_LINKATTR')
begin  
alter table LinkAttr drop constraint I_LINKATTR
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_LinkAttr_LinkExcel') AND parent_object_id = OBJECT_ID(N'LinkAttr'))
BEGIN
alter table LinkAttr drop constraint FK_LinkAttr_LinkExcel
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='LinkExcel' AND CONSTRAINT_NAME='I_LInkExcel')
begin 
alter table LinkExcel drop constraint I_LInkExcel
end
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_LinkExcel' AND object_id = OBJECT_ID('LinkExcel'))
BEGIN
Create Unique Index I_LinkExcel on LinkExcel(ExcelNo, Sheet, Row, Col, Account)
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_LinkAttr' AND object_id = OBJECT_ID('LinkAttr'))
BEGIN
Create Unique Index I_LinkAttr on LinkAttr(ExcelNo, Sheet, Row, Col, Account)
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='LinkAttr' AND CONSTRAINT_NAME='FK_LinkAttr_LinkExcel')
BEGIN       
	ALTER TABLE LinkAttr DROP CONSTRAINT FK_LinkAttr_LinkExcel
END
GO

ALTER TABLE LinkAttr  WITH NOCHECK ADD  CONSTRAINT FK_LinkAttr_LinkExcel FOREIGN KEY(ExcelNo, Sheet, Row, Col, Account)
REFERENCES LinkExcel (ExcelNo, Sheet, Row, Col, Account)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

--FACULTATIVE : PENAMBAHAN OPTION NOT APPLY DISCOUNT CF

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotApplyDiscountCFF' AND Object_ID = Object_ID(N'RARRDET'))
BEGIN

ALTER TABLE RARRDET ADD
	NotApplyDiscountCFF bit NULL
DECLARE @v sql_variant 
SET @v = N'0 : Apply Payor Discount for Type CF ; 1 Not Apply'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RARRDET', N'COLUMN', N'NotApplyDiscountCFF'
end
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = OBJECT_ID(N'QFACOUTDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFACOUTDET  END 
GO

CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, cast(0 as Float) as OCommAmount, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm, RArrDet.NotApplyDiscountCFF
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.OCommAmount, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm, RArrDet.NotApplyDiscountCFF
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = OBJECT_ID(N'QFacultative_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_Data  END 
GO

CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF, R.NotApplyDiscountCFF,
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


go

--8 Nov 2018
Alter Table CLAIM Alter Column BatchNo Varchar(30)
Alter Table SysBatchUp Alter Column BatchNo Varchar(30) 
Alter Table RPBucket Alter Column BatchNo Varchar(30)
Alter Table AIBucket Alter Column BatchNo Varchar(30)

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BatchNo' AND Object_ID = Object_ID(N'TOIVALUE'))
BEGIN
ALTER TABLE TOIVALUE ADD BATCHNO VARCHAR (30) null
END
GO
Alter Table TOIVALUE Alter Column BatchNo Varchar(30)
Alter Table AdmLink Alter Column BatchNo Varchar(30)
Alter Table SysBatchH Alter Column BatchNo Varchar(30)
Alter Table SysBatchD Alter Column BatchNo Varchar(30)
Alter Table SysBatchOriginalBC Alter Column BatchNo Varchar(30)
Alter Table SysBatchBC Alter Column BatchNo Varchar(30)
Alter Table SysBatchOriginalBE Alter Column BatchNo Varchar(30)
Alter Table Scheme_Transaction Alter Column BatchNo Varchar(30)
Alter Table SysBatchBE Alter Column BatchNo Varchar(30)
Alter Table SysBatchOriginalSC Alter Column BatchNo Varchar(30)
Alter Table SysBatchSC Alter Column BatchNo Varchar(30)
Alter Table SysBatchOriginalUp Alter Column BatchNo Varchar(30)
Alter Table ACCLINK Alter Column BatchNo Varchar(30)
Alter Table ACCEPTANCE Alter Column BatchNo Varchar(30)
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Payment_OC' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
alter table RPBucket add Payment_OC Float
END
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'HEmail_Rule') AND type in (N'U'))
BEGIN
CREATE TABLE HEmail_Rule(
	Category varchar(3) NOT NULL,
	ERule varchar(10) NOT NULL,
	Recipient varchar(255) NULL,
	CC varchar(255) NULL,
	Subject varchar(100) NULL,
	Body varchar(2000) NULL,
	SQL varchar(2000) NULL,
	Param01 varchar(50) NULL,
	Param02 varchar(50) NULL,
	Param03 varchar(50) NULL,
	Param04 varchar(50) NULL,
	Param05 varchar(50) NULL,
	Param06 varchar(50) NULL,
	Param07 varchar(50) NULL,
	Param08 varchar(50) NULL,
	Param09 varchar(50) NULL,
	Param10 varchar(50) NULL,
	Param11 varchar(50) NULL,
	Param12 varchar(50) NULL,
	Param13 varchar(50) NULL,
	Param14 varchar(50) NULL,
	Param15 varchar(50) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
	LastEmail smalldatetime NULL,
 CONSTRAINT PK_HEmail_Rule PRIMARY KEY CLUSTERED 
(
	Category ASC,
	ERule ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Param11' AND Object_ID = Object_ID(N'HEmail_Rule'))
BEGIN
alter table HEmail_Rule add Param11	varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Param12' AND Object_ID = Object_ID(N'HEmail_Rule'))
BEGIN
alter table HEmail_Rule add Param12	varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Param13' AND Object_ID = Object_ID(N'HEmail_Rule'))
BEGIN
alter table HEmail_Rule add Param13	varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Param14' AND Object_ID = Object_ID(N'HEmail_Rule'))
BEGIN
alter table HEmail_Rule add Param14	varchar(50)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Param15' AND Object_ID = Object_ID(N'HEmail_Rule'))
BEGIN
alter table HEmail_Rule add Param15	varchar(50)
END
GO


--penambahan RITABARUF

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RITabarruF' AND Object_ID = Object_ID(N'ACCFD'))
BEGIN
ALTER TABLE ACCFD ADD
	RITabarruF bit NULL
DECLARE @v sql_variant 
SET @v = N'Contribute OP to Net Treaty Tabarru (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCFD', N'COLUMN', N'RITabarruF'
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'AssetPic') AND type in (N'U'))
BEGIN
CREATE TABLE AssetPic(
	Asset varchar(20) NOT NULL,
	ImageID int NOT NULL,
	FileType varchar(10) NULL,
	Title varchar(255) NULL,
	Remark text NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
 CONSTRAINT I_AssetPic PRIMARY KEY NONCLUSTERED 
(
	Asset ASC,
	ImageID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE AssetPic  WITH CHECK ADD  CONSTRAINT FK_AssetPic_Asset FOREIGN KEY(Asset)
REFERENCES Asset (Asset)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE dbo.AssetPic CHECK CONSTRAINT FK_AssetPic_Asset
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Asset No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AssetPic', @level2type=N'COLUMN',@level2name=N'Asset'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AssetPic', @level2type=N'COLUMN',@level2name=N'ImageID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AssetPic', @level2type=N'COLUMN',@level2name=N'FileType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AssetPic', @level2type=N'COLUMN',@level2name=N'Title'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AssetPic', @level2type=N'COLUMN',@level2name=N'Remark'
END
GO

--length
Alter Table InvFundH Alter Column LAST_OPR Varchar(50)
GO
Alter Table AssCat Alter Column Last_Opr Varchar(50)
GO
Alter Table Investment_Hist Alter Column Last_Opr Varchar(50)
GO
Alter Table RPBucket Alter Column Last_Opr Varchar(50)
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'Investment'))
BEGIN
ALTER TABLE Investment ADD Last_Opr Varchar(50)
end
GO
UPDATE Investment SET Last_Opr = '' WHERE Last_Opr IS NULL
GO
Alter Table Investment Alter Column Last_Opr Varchar(50)
GO
Alter Table AssetPic Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentBType Alter Column Last_Opr Varchar(50)
GO
Alter Table AssType Alter Column Last_Opr Varchar(50)
GO
--Alter Table AgentGroup Alter Column Last_Opr Varchar(50)
--GO
--Alter Table AgentLBD1 Alter Column Last_Opr Varchar(50)
--GO
--Alter Table AgentLBD2 Alter Column Last_Opr Varchar(50)
--GO
--Alter Table AgentLBD3 Alter Column Last_Opr Varchar(50)
--GO
--Alter Table AgentLBD4 Alter Column Last_Opr Varchar(50)
--GO
--Alter Table AgentLBD5 Alter Column Last_Opr Varchar(50)
--GO
Alter Table AgentLBH Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentLClass Alter Column Last_Opr Varchar(50)
GO
Alter Table tVoucher Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentLevel Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentRType Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentTClass Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentTSegment Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentTType Alter Column Last_Opr Varchar(50)
GO
Alter Table AgentType Alter Column Last_Opr Varchar(50)
GO
Alter Table AIF Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFBenefit Alter Column Last_Opr Varchar(50)
GO
Alter Table WordingPIC Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFBucket Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFPParamD Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFPParamH Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFReward Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFSummaryD Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFSummaryH Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFTraining Alter Column Last_Opr Varchar(50)
GO
Alter Table AIFTrans Alter Column Last_Opr Varchar(50)
GO
Alter Table DType Alter Column Last_Opr Varchar(50)
GO
--Alter Table CouponType Alter Column Last_Opr Varchar(50)
--GO
Alter Table InvGroup Alter Column Last_Opr Varchar(50)
GO
Alter Table InvDocStat Alter Column LAST_OPR Varchar(50)
GO
Alter Table ProfilePIC Alter Column Last_Opr Varchar(50)
GO
Alter Table InvPic Alter Column Last_Opr Varchar(50)
GO
Alter Table InvFundD Alter Column LAST_OPR Varchar(50)
GO
Alter Table HEmail_Rule Alter Column Last_Opr Varchar(50)
GO

alter table PCALC alter column description varchar(MAX)
go

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='IX_SQLdoctor_134_1_a86632fdeb244fbfa4b4aaaf5dd16768' AND object_id = OBJECT_ID('Admlink'))
BEGIN
drop index Admlink.IX_SQLdoctor_134_1_a86632fdeb244fbfa4b4aaaf5dd16768
END
go


--17 des 2018

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loading' AND Object_ID = Object_ID(N'ICalc'))
BEGIN
ALTER TABLE ICalc ADD
	Loading float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Calculated Rate Loading (100%)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ICalc', N'COLUMN', N'Loading'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loading' AND Object_ID = Object_ID(N'RCalc'))
BEGIN
ALTER TABLE RCalc ADD
	Loading float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Calculated Rate Loading (100%)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCalc', N'COLUMN', N'Loading'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Loading' AND Object_ID = Object_ID(N'PCalc'))
BEGIN
ALTER TABLE PCalc ADD
	Loading float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Calculated Rate Loading (100%)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PCalc', N'COLUMN', N'Loading'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GrossBLF' AND Object_ID = Object_ID(N'AAccBS'))
BEGIN
ALTER TABLE AAccBS ADD
	GrossBLF bit NULL
DECLARE @v sql_variant 
SET @v = N'Gross Commission Before Rate Loading (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AAccBS', N'COLUMN', N'GrossBLF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GrossBLF' AND Object_ID = Object_ID(N'ACCBS'))
BEGIN
ALTER TABLE ACCBS ADD
	GrossBLF bit NULL
DECLARE @v sql_variant 
SET @v = N'Gross Commission Before Rate Loading (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCBS', N'COLUMN', N'GrossBLF'
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = OBJECT_ID(N'QPCALC_ACCASS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QPCALC_ACCASS END
GO
CREATE Procedure QPCALC_ACCASS (@P_ANO integer)     
AS     
SELECT ICALC.CURRENCY, ICALC.CODE, 
coalesce(P.InstDate, ICalc.SDate) as SDate,
coalesce(P.InstLDate, ICalc.EDate) as EDate,
(Case When A1.AType='A' Then 0 else ICover.Adjustable end) as AdjustableF, ICALC.SANO, A2.LANO,     
Cast(Max(cast(RCover.NoRefundF as Integer)) as Bit) as NoRefundF,     
Max(Case When ICover.Adjustable=1 Then TOI.AdjMethod else '' end) as AdjMethod,     
AVG(ICALC.PRORATA) AS PPRORATA, 
MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as SHARE, 
SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*RCALC.GROSS/RCALC.OGROSS end*coalesce(P.InstPCT,100)/100) AS GROSS,     
CAST(MAX(Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end) as Bit) as MinimumPremiumF,     
SUM(ICALC.REINSTATEMENT) AS REINSTATEMENT,     
SUM(ICALC.DISCOUNT) AS DISCOUNT,     
SUM(ICALC.LOADING) AS LOADING,     
MAX(PCALC.TSI) as TSI,      --100% Sum Insured for Reinsurance Rate     
MAX(PCALC.Rate) As Rate     
FROM ICover     
inner join ICALC on (ICALC.INO=ICOVER.INO and ICALC.ANO=ICOVER.ANO)     
inner join TOI on (TOI.TOI=ICOVER.TOI)     
inner join RCALC on (ICALC.ANO=RCALC.ANO AND ICALC.CURRENCY=RCALC.CURRENCY AND ICALC.CODE=RCALC.CODE AND ICALC.TOR=RCALC.TOR AND ICALC.SDATE=RCALC.SDATE AND ICALC.EDATE=RCALC.EDATE AND ICALC.SANO=RCALC.SANO)     
inner join PCALC on (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)     
Left join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)     
inner join ACCEPTANCE A1 On (A1.ANO=ICALC.ANO)     
inner join ACCEPTANCE A2 on (A2.ANO=ICALC.SANO)     
Inner Join RArrHeader R on (R.ANO=ICalc.ANO)     
left join ISource on (ISource.CNO=A2.CNO)     
Left Join Payor_Schedule P on (P.ANO=@P_ANO)
WHERE ICover.ANO=@P_ANO and ICALC.GROSS<>0 AND ICALC.SDATE<>ICALC.EDATE  
GROUP BY ICALC.CURRENCY, ICALC.CODE, coalesce(P.InstDate, ICalc.SDate), coalesce(P.InstLDate, ICalc.EDate), (Case When A1.AType='A' Then 0 else ICover.Adjustable end), ICalc.SANO, A2.LANO     

GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RCalc_ANO_Code' AND object_id = OBJECT_ID('RCalc'))
BEGIN
Create Index I_RCalc_ANO_Code on RCalc(ANO, Code)
end
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Rate_Discount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION Rate_Discount END
GO

CREATE function Rate_Discount(@P_ANO as int, @P_Code as varchar(10))
RETURNS Table
AS RETURN            
(          
Select sum(R.Discount*P.Rate)/sum((R.OGross+R.Discount-R.Loading)*P.Rate)*100 as Discount, sum(R.OGross*P.Rate)/sum(R.Loading*P.Rate) as Loading
from PCalc P, RCalc R Where P.ANO=R.ANO and P.Currency=R.Currency and R.ANO=@P_ANO and R.Code=@P_Code
having sum((R.OGross+R.Discount-R.Loading)*P.Rate)<>0 and sum(R.Loading*P.Rate)<>0
)              

go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DiscUnit' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD
	DiscUnit varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Rate Discount Unit (C/M/F)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'DiscUnit'
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = OBJECT_ID(N'PCALC01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN
DROP PROCEDURE PCALC01 END
GO

CREATE Procedure PCALC01(@P_ANO integer)    
As    
SELECT  ACCEPTANCE.TOC,    
  COVER.PPERIOD,    
  COVER.PRORATA,    
  COVER.VOYAGE,    
  CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
  RCOVER.CODE,    
  RATECOV.TOR,    
  Case 
  When RCOVER.DISCUNIT='M' THEN
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)/10
  When RCOVER.DISCUNIT='F' THEN
	  (RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
	  /
	  (
	  CASE 
	  WHEN RCOVER.UNIT='L' Then 0 
	  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*DBO.FN_RATE_LOADING(RCOVER.ANO)
	  ELSE RCOVER.RATE
	  END
	  *
	  CASE
	  WHEN RCOVER.UNIT='C' THEN ICOVER.SI/100
	  WHEN RCOVER.UNIT='M' THEN ICOVER.SI/1000
	  WHEN RCOVER.UNIT='F' THEN 1
	  END
	  )*100
  ELSE
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
  END AS DISCOUNT,
  RCOVER.LOADING,    
  CASE 
  WHEN RCOVER.UNIT='L' Then 0 
  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*DBO.FN_RATE_LOADING(RCOVER.ANO)
  ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION
  END AS RATE,
  RATECOV.PORTION,    
  RCOVER.SDATE,    
  RCOVER.EDATE,    
  RCOVER.PCALC,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 0 else RCOVER.PADDITION end as PADDITION,    
  CASE WHEN ICOVER.NOTFLF=1 THEN 100 ELSE RCOVER.PPRORATA END AS PPRORATA,
  ICOVER.CURRENCY,    
  ICOVER.SI,    
  ICOVER.INDEMNITY,    
  (Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
  ICOVER.Adjustable,    
  ICOVER.PCTADJ,    
  ICOVER.INO,    
  ACCEPTANCE.ANO as SANO,    
  PolicyType.SType
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, ACCEPTANCE, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)    
WHERE  ACCEPTANCE.ANO=@P_ANO    
  And COVER.CNO=ACCEPTANCE.CNO    
  And RCLASS.TOC=ACCEPTANCE.TOC    
  And RCOVER.ANO=ACCEPTANCE.ANO    
  And ICOVER.ANO=ACCEPTANCE.ANO    
  And RATECOV.CODE=RCOVER.CODE    
  And RCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOI=ICOVER.TOI    
  And TOI.TOI=ICOVER.TOI    
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE, ACCEPTANCE.ANO


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = OBJECT_ID(N'PCALC01_ADJ') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE PCALC01_ADJ END
GO

CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  COVER.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
Case 
  When RCOVER.DISCUNIT='M' THEN
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)/10
  When RCOVER.DISCUNIT='F' THEN
	  (RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
	  /
	  (
	  CASE 
	  WHEN RCOVER.UNIT='L' Then 0 
	  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*DBO.FN_RATE_LOADING(RCOVER.ANO)
	  ELSE RCOVER.RATE
	  END
	  *
	  CASE
	  WHEN RCOVER.UNIT='C' THEN ICOVER.SI/100
	  WHEN RCOVER.UNIT='M' THEN ICOVER.SI/1000
	  WHEN RCOVER.UNIT='F' THEN 1
	  END
	  )*100
  ELSE
	(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)
  END AS DISCOUNT,
RCOVER.LOADING,   
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end*DBO.FN_RATE_LOADING(RCOVER.ANO)
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  ACCEPTANCE A1
INNER JOIN ACCEPTANCE A2 ON (A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C'))
INNER JOIN COVER ON (COVER.CNO=A1.CNO)
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)
INNER JOIN ICOVER ON (ICOVER.ANO=A1.ANO AND ICOVER.ADJUSTABLE=1)
INNER JOIN RCOVER ON (RCOVER.ANO=A2.ANO)
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE)
INNER JOIN RCLASS ON (RCLASS.TOC=A1.TOC AND RCLASS.TOR=RATECOV.TOR)
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND PCLASS.TOI=ICOVER.TOI)
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)
INNER JOIN RCALC ON (RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate)
Where A1.ANO=@P_ANO AND A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   


go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AgentType' AND Object_ID = Object_ID(N'ACCBS'))
BEGIN
ALTER TABLE ACCBS ADD
	AgentType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Agent Type (see AgentType Table) Refer To AIF'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCBS', N'COLUMN', N'AgentType'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AgentType' AND Object_ID = Object_ID(N'AAccBS'))
BEGIN
ALTER TABLE AAccBS ADD
	AgentType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Agent Type (see AgentType Table) Refer To AIF'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AAccBS', N'COLUMN', N'AgentType'
end
GO

IF NOT EXISTS(SELECT * FROM Sysform WHERE FName='ALLOWCHANGEAGENTTYPE')
BEGIN
Insert into Sysform (FName, Description, FCode, RequestF)
Select 'ALLOWCHANGEAGENTTYPE','Allow Change Agent Type (Business Source)','ACTIVITIES',0
end
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserBusinessSource') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FN_UserBusinessSource END
GO

CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF,P.TaxF, P.NetCommF, P.RestrictedF, P.LOB, 
S1.ID as SID, S1.Name as SName,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID)
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
and (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
and
(
@P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or NOT EXISTS (Select PID from SysUserAssignment S Where S.PID=P.ID and S.AssType='SOURCE' and S.ID<>@P_UserID)
)
)    
go


IF NOT EXISTS(SELECT * FROM sysform WHERE FName='FORCEFILLDETAILCT')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'FORCEFILLDETAILCT','FORCE FILL DETAIL CT (FA)','ACTIVITIES',0
end
go

--VERSIONING
insert into versioning
select '2018 V.2.1.0',GETDATE(),'2018 V.2.1.0',GETDATE(),'K: 2018 V.2.1.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='50.1 Update Script - Patch 2018 (1) (Execute Before Kom 2018 v.2.1)'
Select @CurrSCript='51 Script Komulatif Konsol 2018 2.1'


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