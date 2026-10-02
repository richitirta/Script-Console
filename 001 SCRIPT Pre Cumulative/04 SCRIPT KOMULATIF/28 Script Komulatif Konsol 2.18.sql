--10 OKT 2017 : setting tetap dapat menggunakan setting Reinsurance Rate (di Table of Limit) tetapi Rate bisa dikosongkan untuk mengambil nilai sesuai exchange rate-nya
DROP Procedure QREINSURANCE_RATE
GO
CREATE Procedure QREINSURANCE_RATE(@P_ANO integer, @P_CURRENCY varchar(10)) 
as 
SELECT ReRate.CCYTo,
Case 
When ReRate.Rate<>0 Then ReRate.Rate 
Else 
	Case
	When ReRate.CCYTO='' or ReRate.CCYTO=@P_Currency Then 1
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
From Acceptance 
Inner Join SysTab on (1=1)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join ReRate on ( 
ReRate.TOC=Acceptance.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=Acceptance.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Acceptance.ANO=@P_ANO 

GO

DROP Procedure QCLAIM_RATE
GO
CREATE Procedure QCLAIM_RATE(@P_CNO integer, @P_CURRENCY varchar( 10))
as
SELECT ReRate.CCYTo,
Case 
When ReRate.CRate<>0 Then ReRate.CRate 
When ReRate.Rate<>0 Then ReRate.Rate 
Else 
	Case
	When ReRate.CCYTO='' or ReRate.CCYTO=@P_Currency Then 1
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as CRate
From Claim
Inner Join SysTab on (1=1)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join ReRate on ( 
ReRate.TOC=ACCEPTANCE.TOC 
and ReRate.RYear=coalesce(( 
	Select Top 1 R1.RYear 
	from Reinsurance R1, ReClass R2 
	Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
	Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=ACCEPTANCE.TOC and RArrHeader.RDate Between R1.SDate and R1.EDate 
	Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Claim.CNO=@P_CNO


 

GO
--18 okt 2017
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
Select -6,'Claim Amount','Claim Amount','Claim Amount','Claim Amount'
Union all
Select -7,'Premium Adjustment','Premium Adjustment','Deductible','Deductible Amount'
Union all
Select -8,'Profit Sharing','Profit Sharing','Salvage Amount','Salvage'
Union all
Select -9,'--Un-Used--','--Un-Used--','Claim Expenses','Claim Expenses'
Union all
Select -10,'Subrogation','Subrogation','Subrogation','Subrogation Amount'
Union all
Select -11,'Other Income','Other Income (Premium)','--Un-Used--','--Un-Used--'
Union all
Select -12,'--Un-Used--','--Un-Used--','Other Income','Other Income (Claim)'
Union all
Select -13,'PPN (VAT)','Pajak Pertambahan Nilai','PPN (VAT)','Pajak Pertambahan Nilai'
Union all
Select -14,'PPH (TAX)','Pajak Penghasilan','PPH (TAX)','Pajak Penghasilan'
Union all
Select -15,'Others Fee/Duty #1','Others Fee/Stamp Duty #1','Others Fee','Others Fee'
Union all
Select -16,'Others Fee/Duty #2','Others Fee/Stamp Duty #2','Claim Stamp Duty','Claim Stamp Duty'
Union all
Select -17,'Others Tax #1','Others Tax #1','Claim Adjustment','Claim Adjustment'
Union all
Select -18,'Others Tax #2','Others Tax #2','--Un-Used--','--Un-Used--'
Union all
Select -19,'Deposit/Reserve','Deposit/Reserve','--Un-Used--','--Un-Used--'
Union all
Select -20,'Ujroh Cedant','Ujroh Cedant','--Un-Used--','--Un-Used--'

Update Hint Set Last_Opr='CARE', Last_Update='12/31/2016'

GO
DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, Max(A1.DocNo) as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
(Select Top 1 TreatyInstallmentF from reinsurance Where Reinsurance.docNo=A1.RefNo) as TreatyInstallmentF,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
Max(Branch.VAT) as BVATPCT,
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='O' and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_7,                              
sum(Case When A1.Code='O' and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_8,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Branch on (Branch.Branch=Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end)
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 
GO

DROP Procedure QUndo_Production_To_Adm
GO
CREATE Procedure QUndo_Production_To_Adm(@P_ANO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                      
sum(Case When A1.Code='F' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_3,                      
sum(Case When A1.Code='D' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_4,                      
sum(Case When A1.Code='O' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_5,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='O' and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_7,                      
sum(Case When A1.Code='O' and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_8,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code in ('D','F') and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_15,     
sum(Case When A1.Code in ('D','F') and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_16,     
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,                      
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                      
from AccAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.ANO=@P_ANO                      
Group By A1.AdmNo    
                

go


DROP FUNCTION [dbo].[FN_QTOPDedCode]
go
CREATE FUNCTION [dbo].[FN_QTOPDedCode] (@p_TOPRO varchar(10), @p_DCode varchar(10))
RETURNS TABLE  
AS RETURN (  
	Select Distinct Dedtab.DCODE, Dedtab.REMARKS, Dedtab.REMARKS_1, Dedtab.PCTTSI, PCTCL, FIXEDMIN, FIXEDMAX, CURRENCY, IUNIT
	From Rclass, DedTAB, TOPRO
	Where TOPRO.TOPRO=@P_TOPRO AND Rclass.TOC=TOPRO.TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
) 
go

--20 OCT 2017
Alter Table RPBucket Add NetPaidF Bit
GO
UPdate RPBucket Set NetPaidF=0 Where NetPaidF is null
GO

insert into SysForm(FName, Description, FCode) Select 'ALLOWCHANGECHEQUENO', 'ALLOW CHANGE CHEQUENO','ACTIVITIES'
GO


--24 okt 2017
DROP Function Get_TaxType
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20))          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float

Select @TaxType=TaxType from TaxType Where TaxType=@P_TaxType and coalesce(Lower,0)=0 and coalesce(Upper,0)=0
 
if @TaxType is null
Begin


	Select @PNominal_Tax=sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate)
	from pSL SL, pVoucher, nVoucher V, Admlink A
	where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
	and A.Type in ('BB','BA','BC')
	and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
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

--24 okt 2017
DROP Procedure qPolicy_Data
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
Interest.Currency, Interest.TSI, Interest.ATSI,                              
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
WHERE A1.ANO=@P_ANO 

GO

DROP Procedure QCertificate_Data
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                               
Interest.Currency, Interest.TSI, Interest.ATSI,                            
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
WHERE A1.ANO=@P_ANO       




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
ALTER TABLE dbo.APDBucket ADD
    NeedPrintF bit Null,
	PrintF bit NULL
GO
ALTER TABLE dbo.APDBucket SET (LOCK_ESCALATION = TABLE)
GO
UPDATE APDBUCKET SET NeedPrintF=0 WHERE NeedPrintF IS NULL
UPDATE APDBUCKET SET PRINTF=0 WHERE PRINTF IS NULL
COMMIT

--VERSIONING
insert into versioning
select '2017 V.2.18.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
