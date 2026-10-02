alter Table pJournal drop constraint FK_pJournal_pVoucher
GO
alter Table pSL drop constraint FK_pSL_pVoucher
GO
alter Table pSLSum drop constraint FK_pSLSum_pVoucher
GO
alter Table ORPrintLog drop constraint FK_ORPrintLog_pVoucher
GO
alter Table pSLRef drop constraint FK_pSLRef_pVoucher
GO
ALTER TABLE [dbo].[RPBucket] DROP CONSTRAINT [FK_RPBUCKET_PVOUCHER]
GO
alter Table pVoucher drop constraint I_PVoucher
GO
DROP View  SL
GO
alter table pSLSUm drop constraint I_pSLSum
GO

Drop index pSLSUM.I_pSLSum_Voucher
GO
Drop Index pVoucher.I_PVoucher_Date
GO

DROP INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
GO
DROP INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
GO
alter table pVoucher alter column Voucher varchar(30) Not Null
GO
alter table pJournal alter column Voucher varchar(30)
GO
alter table pSL alter column Voucher varchar(30)
GO
alter table pSLSum alter column Voucher varchar(30) Not Null
GO
alter table ORPrintLog alter column Voucher varchar(30)
GO
alter table pSLRef alter column Voucher varchar(30)
GO
alter table RPBucket alter column Voucher varchar(30) Not Null
GO
Create index I_PVoucher_Date on pVoucher(Date) include(Voucher)
GO
Alter Table pVoucher add constraint I_pVoucher Primary Key (Voucher)
GO
Alter Table pSLSum add constraint I_pSLSum Primary Key (Voucher, Branch, Account)
GO
ALTER TABLE pJournal WITH NOCHECK ADD  CONSTRAINT FK_pJournal_pVoucher FOREIGN KEY(Voucher)
REFERENCES pVoucher (Voucher) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE pSL WITH NOCHECK ADD  CONSTRAINT FK_pSL_pVoucher FOREIGN KEY(Voucher)
REFERENCES pVoucher (Voucher) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE pSLSum WITH NOCHECK ADD  CONSTRAINT FK_pSLSum_pVoucher FOREIGN KEY(Voucher)
REFERENCES pVoucher (Voucher) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE ORPrintLog WITH NOCHECK ADD  CONSTRAINT FK_ORPrintLog_pVoucher FOREIGN KEY(Voucher)
REFERENCES pVoucher (Voucher) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE pSLRef WITH NOCHECK ADD  CONSTRAINT FK_pSLRef_pVoucher FOREIGN KEY(Voucher)
REFERENCES pVoucher (Voucher) ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE [dbo].[RPBucket]  WITH NOCHECK ADD  CONSTRAINT [FK_RPBUCKET_PVOUCHER] FOREIGN KEY([Voucher])
REFERENCES [dbo].[pVoucher] ([Voucher])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [I_RPBUCKET_VOUCHER_NVOUCHER] ON [dbo].[RPBucket]
(
	[Voucher] ASC,
	[NVOUCHER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


DROP function PAID_VOUCHER
GO
CREATE function PAID_VOUCHER(@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
Select VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, DOCNO, VTYPE, NOMINAL from Paid_Voucher_N(@P_Voucher)
Union All
Select VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, DOCNO, VTYPE, NOMINAL from Paid_Voucher_P(@P_Voucher)
)

GO

DROP function PAID_VOUCHER_N 
GO
CREATE function PAID_VOUCHER_N (@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
SELECT VN.VOUCHER, VN.DATE, VN.CURRENCY, VN.PROACC, VN.DEBTORF, VN.CREDITORF, VN.SL_CAT, VN.BRANCH, VN.REFNO, VN.DOCNO, VN.VTYPE,
VN.NOMINAL_CC-VN.DIFF_CC-VN.PAYMENT_CC-VN.PAYMENT_OC+CASE WHEN  (VP.SL_CAT='O') OR (VP.SL_CAT IN ('P')  AND VN.SL_CAT='P' AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('C','U')  AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('P','A','B') AND
VN.SL_CAT='N' AND VP.DEBTORF=VN.DEBTORF)  THEN SL.NOMINAL_OC ELSE  -SL.NOMINAL_OC END AS NOMINAL
FROM nVOUCHER Vn, pVOUCHER Vp, OSL(@P_Voucher) SL
WHERE Vn.VOUCHER=SL.DOC_NO and SL.PAYMENTF=1 AND VP.VOUCHER=SL.VOUCHER AND VP.VOUCHER=@P_VOUCHER
)
  


GO
DROP function PAID_VOUCHER_P
GO
CREATE function PAID_VOUCHER_P (@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
SELECT VN.VOUCHER, VN.DATE, VN.CURRENCY, VN.PROACC, VN.DEBTORF, VN.CREDITORF, VN.SL_CAT, VN.BRANCH, VN.REFNO, VN.DOCNO, VN.VTYPE,
VN.NOMINAL_CC-VN.DIFF_CC-VN.PAYMENT_CC-VN.PAYMENT_OC+CASE WHEN  (VP.SL_CAT='O') OR (VP.SL_CAT IN ('P')  AND VN.SL_CAT='P' AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('C','U')  AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('P','A','B') AND
VN.SL_CAT='N' AND VP.DEBTORF=VN.DEBTORF)  THEN SL.NOMINAL_OC ELSE  -SL.NOMINAL_OC END AS NOMINAL
FROM pVOUCHER Vn, pVOUCHER Vp, OSL(@P_Voucher) SL
WHERE Vn.VOUCHER=SL.DOC_NO and SL.PAYMENTF=1 AND VP.VOUCHER=SL.VOUCHER AND VP.VOUCHER=@P_VOUCHER
)
  

GO

DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(30)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, OVoucher.Currency, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

GO

DROP function OS_VOUCHER 
GO
CREATE function OS_VOUCHER (@P_Voucher Varchar(30))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, REFDATE, DOCNO, VTYPE, REMARKS, REFTYPE, A_Refno, ACCOUNTNO, NOMINAL, TAX, PAYMENT, OUTSTANDING, ACCOUNT, HINT
FROM OS_VOUCHER_N(@P_VOUCHER)    
Union All    
SELECT VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, REFDATE, DOCNO, VTYPE, REMARKS, REFTYPE, A_Refno, ACCOUNTNO, NOMINAL, TAX, PAYMENT, OUTSTANDING, ACCOUNT, HINT    
FROM OS_VOUCHER_P(@P_VOUCHER)    
)    
GO
DROP function OS_VOUCHER_N 
GO
CREATE function OS_VOUCHER_N (@P_Voucher Varchar(30))        
RETURNS Table        
AS RETURN        
(        
SELECT DISTINCT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,        
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,        
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,        
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,    
'' AS ACCOUNT,  
cast(0 as Smallint) as HINT    
FROM NVoucher VOUCHER 
Inner Join Admlink On (Admlink.Voucher=Voucher.Voucher)        
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)        
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
)        

GO
DROP function OS_VOUCHER_P 
GO
CREATE function OS_VOUCHER_P (@P_Voucher Varchar(30))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
Cast(0 as Float) as TAX,
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
 FROM R_SL_ALLOCATED_BY_VOUCHER('') SL, PVOUCHER
 WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
 ) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 

GO

DROP function OPEN_VOUCHER
GO
CREATE function OPEN_VOUCHER(@P_VOUCHER VARCHAR(30),@P_Branch Varchar(10)='', @P_Account varchar(10)='')
RETURNS Table
AS RETURN
(
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_N(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
Union All
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_P(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
)

GO

DROP function OPEN_VOUCHER_P
GO
CREATE function OPEN_VOUCHER_P(@P_VOUCHER VARCHAR(30), @P_Branch Varchar(10)='', @P_Account varchar(10)='')  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF, Max(Voucher.SL_Cat) as SL_Cat, Max(Voucher.Remarks) as Remarks, coalesce(sum(SL_Alloc.Nominal_OC),0) as Payment_CC, Max(SL.Nominal_OC) as Nominal_CC, Cast(0 as Float) as Tax_CC  
from pVoucher Voucher, Get_Open_Item_P(@P_Voucher) SL Left Join Open_Item_Allocated(@P_Voucher) SL_Alloc on (SL_Alloc.Doc_no=SL.Voucher and SL_Alloc.Branch=SL.Branch and SL_Alloc.Account=SL.Account)  
where Voucher.Voucher=SL.Voucher and Voucher.Voucher Like @P_Voucher+'%' and (SL.Branch=@P_Branch or @P_Branch='') and (SL.Account=@P_Account or @P_Account='')  
Group By Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF  
)  
          
  
  
GO  

DROP Function oSL
GO
CREATE Function oSL(@P_Voucher varchar(30)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case 
When VType.Code<>'MATCHING' and pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0 then
	Case When exists(Select Top 1 R.PID from RPBucket R Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>'' and R.Status<>'C') Then cast(1 as Bit) else cast(0 as Bit) end
else
	cast(0 as bit)
end
as BucketF, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF
From dbo.pVoucher 
Inner Join dbo.VType on (VType.VType=pVoucher.VType)
Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 

Go

Create View SL 

as

Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo

from nSL SL

Union All

Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo

from pSL SL

Union All

Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo

from mSL SL


GO




 insert into PatchVersioning
select '205 Update Script - Patch 2022 (18)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='205 Update Script - Patch 2022 (18)'


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