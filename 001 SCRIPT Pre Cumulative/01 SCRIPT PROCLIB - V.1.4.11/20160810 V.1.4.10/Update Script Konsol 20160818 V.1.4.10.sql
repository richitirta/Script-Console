--V.1.4.10
--Revisi untuk QPremiumAmount dimana jika terkait dengan Fleet maka menampilkan informasi terkait dengan Nota Premi Fleet

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QPREMIUMAMOUNT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QPREMIUMAMOUNT] END 
go

CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      
AS                     
Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_Date as smalldatetime  
        
Select   
@P_APolicyNo=Case When Cover.OpenFlag=1 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end,  
@P_Date=Acceptance.ADate  
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO        
        
Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
sum(Voucher.PremiumPaid) as PremiumPaid,          
@P_WPC as WPC,  
@P_BillDate as BillDate,  
Case When sum(Voucher.PremiumPaid)<>0 Then Max(Voucher.PDate) else @P_Date End as Date          
From          
(           
 SELECT                      
 DISTINCT  
 nVoucher.Voucher,  
 CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount,                      
 Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE,                 
  
    
     
 CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid,                      
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate      
          
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.Date<=@P_PDate  
) Voucher  
go


--Perbaikan Inconsisten data Proses claim tidak membaca declare value
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLNOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLNOC] END 
go
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
ICOVERNOC.LIMIT, ICOVERNOC.INDEMNITY                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
          
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
 0 as Indemnity                  
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInConsistent_LossItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QInConsistent_LossItem] END 
go
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int        
Declare @P_COL as varchar(10)        
Declare @P_ANO as int  
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO   
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE    
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI   
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
AND ACCEPTANCE.ANO=@P_ANO  
AND CLLOSS.INO=ICOVER.INO AND CLLOSS.NOC=NOC.NOC  
AND
ROUND(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END,2)=ROUND(CLLOSS.DECLARED,2)
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS          
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL        
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                      
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                          
AND NOC.TOI=ICOVER.TOI AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL        
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)         
AND ACCEPTANCE.ANO=@P_ANO  
AND CLLOSS.INO=ICOVER.INO AND CLLOSS.NOC=NOC.NOC  
AND  
ROUND(CASE  
 WHEN @P_EVENTNO=-1 THEN                          
        CASE                          
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                          
 Else                          
        CASE                          
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                  
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                          
 END,2)=ROUND(CLLOSS.DECLARED,2)   
)  
          
go

--Perubahan Table RPBUcket
alter table rpbucket alter column CT varchar (10)
go

CREATE TABLE [dbo].[Versioning](
	[VerNoApp] [varchar](20) NULL,
	[VerUpdateApp] [smalldatetime] NULL,
	[VerNoWS] [varchar](20) NULL,
	[VerUpdateWS] [smalldatetime] NULL,
	[VerNoProclib] [varchar](20) NULL,
	[VerUpdateProclib] [smalldatetime] NULL,
) 
go


--Inisialisasi
UPDATE MAP_FIELD SET FIELDTO='BSFee1' WHERE fieldTo='BSFee' 
UPDATE MAP_FIELD SET FIELDTO='BSID1' WHERE fieldTo='BSID'



update SysTab Set versionNo='20160818 V1.4.10',versionUpdate=getdate()
go