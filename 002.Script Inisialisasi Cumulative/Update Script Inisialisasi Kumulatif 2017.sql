set transaction isolation level read uncommitted
-- Kumulatif 2017 V.2.31



update Claim set AlreadyScreeningF=0 where AlreadyScreeningF is null
go


Update A1 Set NeedEmailF=A2.NeedEmailF from APDRuleD A1, APDRuleH A2 Where A1.RuleID=A2.RuleiD and A1.NeedEmailF is null
Update APDRULED Set NeedPrintF=0 from APDRULED Where NeedPrintF is null
GO
Update pSL set LockedF=0 Where LockedF is null
GO
Update SL_Request set LockedF=0 Where LockedF is null
GO

update admlink set PNominal_Tax=0 where PNominal_Tax is null
update admlink set PNominal_Vat=0 where PNominal_Vat is null
go

Update pSL set LockedF=0 Where LockedF is null
GO
Update SL_Request set LockedF=0 Where LockedF is null
GO

-- Kumulatif 2017 V.2.30

UPDATE RATETAB SET COMPULSORYF=0 WHERE COMPULSORYF IS NULL
GO

UPDATE PettycashType Set MaxAmount=0 Where MaxAmount is null
GO

-- Kumulatif 2017 V.2.29

UPDATE SYSTAB SET ApplyReinsuranceDepositF=1 Where ApplyReinsuranceDepositF is null
GO

Update Systab Set BIRPermitNo = '', BIRIssueDate = GETDATE()
go

Update PTClass Set TOC='<All>' Where TOC is null
GO

update CLNOTES set SYSTEMF=0 where SYSTEMF is null
go
UPDATE CLINFO SET CLaimant=CLLOSS.CLaimant FROM CLINFO, CLLOSS WHERE CLINFO.CLaimant IS NULL AND CLLOSS.CNO=CLINFO.CNO AND CLLOSS.INO=CLINFO.INO AND CLLOSS.NOC=CLINFO.NOC
GO

Update CollectionH SEt RepDate=CollDate from CollectionH Where CollStatus='R' and RepDate Is null
go

Update pSLRef Set DocRefNo='' Where DocRefNO is null
Update pSLRef Set RefStatus='' Where RefStatus is null
Update pSLRef Set RefNo='' Where RefStatus is null
Update pSLRef Set RefType='' Where RefStatus is null
go

-- Kumulatif 2017 V.2.28

UPDATE CLLOSS SET EDepreciation=0 WHERE  EDepreciation IS NULL
UPDATE CLLOSS SET Depreciation=0 WHERE  Depreciation IS NULL
go


UPDATE Reinsurance SET ApplySegmentF=0 Where ApplySegmentF is null
GO

-- Kumulatif 2017 V.2.27
update Profile set vat=0 where vat is null
go

update Profile set tax=0 where tax is null
go
UPDATE RATECON SET PCALC='' WHERE PCALC IS NULL
GO

-- Kumulatif 2017 V.2.26
Update ICover Set TOPROF=0 Where TOPROF IS NULL
GO
Update RCover Set TOPROF=0 Where TOPROF IS NULL
go


Update AccAss Set CodeExt='' Where CodeExt is null
go

update SysRequest set duedate=GETDATE() where duedate is null
go

-- Kumulatif 2017 V.2.25
update clitem set EDepreciation=0 where EDepreciation is null
update clitem set Depreciation=0 where Depreciation is null
update clitem set PCTLoss=0 where PCTLoss is null
go

UPDATE TOC Set VATInstallmentF=0 Where VATInstallmentF is null
GO
UPDATE AACCBS Set BSID=ID Where BSID is null
GO
UPDATE ACCBS Set BSID=ID Where BSID IS NULL
GO


update admlink set ASOURCE='' where asource is null
go

UPDATE ACCCNC SET CNCSTATUS='A' WHERE CNCSTATUS IS NULL
GO

-- Kumulatif 2017 V.2.24
Update mVoucher Set AutoReverseF=0 Where AutoReverseF is null
go
UPDATE RPART SET BRComm=0 WHERE BRComm IS NULL
GO

-- Kumulatif 2017 V.2.23
UPDATE ADMLINK SET PAYMENT=0 WHERE PAYMENT IS NULL
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


-- Kumulatif 2017 V.2.22
UPDATE RCOVER SET MPREMIUM=0 WHERE MPREMIUM IS NULL
go

-- Kumulatif 2017 V.2.21
UPDATE CLDED SET REFNO='' WHERE REFNO IS NULL
GO

-- Kumulatif 2017 V.2.20

UPDATE CLCOST SET REFNO='' WHERE REFNO IS NULL
GO

Update REINSURANCE Set COMM = 0 where COMM is null
go
Update REINSURANCE Set COMMN = 0 where COMMN is null
go

-- Kumulatif 2017 V.2.19 (KOSONG)
-- Kumulatif 2017 V.2.18

UPdate RPBucket Set NetPaidF=0 Where NetPaidF is null
GO

UPDATE APDBUCKET SET NeedPrintF=0 WHERE NeedPrintF IS NULL
UPDATE APDBUCKET SET PRINTF=0 WHERE PRINTF IS NULL
GO

-- Kumulatif 2017 V.2.17

UPDATE TOP_DEDUCTIBLE SET NotApplyRateLoadingF=0 Where NotApplyRateLoadingF IS NULL
GO
UPDATE PROFILE SET BVATF=0 Where BVATF IS NULL
UPDATE PROFILE SET TVATF=0 Where TVATF IS NULL
GO

Update TOC Set ObjectRestrictionF=0 Where ObjectRestrictionF is null
Update TOC Set EachAccRegF=0 Where EachAccRegF is null
GO

 update ORPrintLog set AmountVersion = 0 where AmountVersion is null 
 go
  update ORPrintLog set PrintVersion = 0 where PrintVersion is null
  go

UPDATE CLDED Set AgreedF=0 Where AgreedF is null
GO

UPDATE CLFACDED Set AgreedF=0 Where AgreedF is null
GO

-- Kumulatif 2017 V.2.16
--Update AccRegDet set RestrictedF=0 Where RestrictedF is null
--GO
--Update AccRegDet set pRestrictedF=0 Where pRestrictedF is null
--GO

Update Request set AUserID='', AUserDate=Null where status='U'
GO
Update APBucket set BookDate=PDate Where BookDate is null
GO

UPDATE CLDED SET VATAMOUNT=AMOUNT, TAXAMOUNT=AMOUNT, VAT=0, TAX=0 WHERE VATAMOUNT IS NULL
GO
UPDATE TOP_DEDUCTIBLE SET NotApplyRateLoadingF=0 Where NotApplyRateLoadingF IS NULL
GO

-- Kumulatif 2017 V.2.15
UPDATE ACCLOG SET PEDATE=dateadd(day,-1,PDATE) FROM ACCLOG WHERE PEDATE IS NULL
GO


Update Profile Set Tax=5 Where TaxF=1 and TaxType='PASAL21'
go

-- Kumulatif 2017 V.2.14

UPDATE SYSFORM Set Description='Allow Change Policy Branch (UW/CL)' Where FName='ALLOWCHANGEBRANCH'
go

Update VType Set Code=CodeExt, Codeext='' from VType Where TaxF=1 and CodeExt not in ('','Premium','Claim')
go

Update Cheque Set Status='O' Where Voucher=''
GO
Update Cheque Set Status='A' Where Voucher<>''
GO

-- Kumulatif 2017 V.2.13

UPDATE TOP_RATE Set Rate_Source='' Where Rate_Source is null
GO

UPDATE MAP_REFERENCE SET TOPRO='' WHERE TOPRO IS NULL
GO

UPDATE SYSFORM Set Description='Allow Change Policy Branch (UW/CL)' Where FName='ALLOWCHANGEBRANCH'
go

-- Kumulatif 2017 V.2.12
Update Profile Set Last_Time = Last_Time + ':00' Where LEN(Last_Time) = 5
GO

Update Profile Set Last_Time = '00:00:00' Where Last_Time = ''
GO
Update Profile Set SYNCDATE = '', SYNCTIME = '00:00:00', SYNCERRORMESSAGE = ''
go


update dedtab set ctlf=0 where ctlf is null
go

-- Kumulatif 2017 V.2.11
UPDATE ACCFD SET AMOUNTPCTBASED=0 WHERE AMOUNTPCTBASED IS NULL
GO
UPDATE TOP_FD SET AMOUNTPCTBASED=0 WHERE AMOUNTPCTBASED IS NULL
GO

Update AccAss Set CodeExt='' Where CodeExt is null
GO
Update ClaAss Set CodeExt='' Where CodeExt is null
GO
UPDATE SYSTAB SET TAXMETHOD=0 WHERE TAXMETHOD IS NULL
GO

Update Admlink Set TaxType='' Where TaxType is null
GO

-- Kumulatif 2017 V.2.10
Update RateTab set TOR='' Where TOR IS NULL
go
UPDATE TOP_RATE set PCTLOSS_SOURCE='' WHERE PCTLOSS_SOURCE IS NULL
GO

UPDATE Scheme_Indemnity_TSI SET PCTLOSS=0, PADDITION=0 WHERE PCTLOSS IS NULL
GO


-- Kumulatif 2017 V.2.9

Update ComAcc Set ChequeSeqNo=0 WHere ChequeSeqNo is null
GO
Update RateTab set TOR='' Where TOR IS NULL
go

-- Kumulatif 2017 V.2.8
UPDATE TOP_RATE SET PCTLOSS=100 WHERE PCTLOSS IS NULL
GO

-- Kumulatif 2017 V.2.7

Update SysProcess Set MainProcName=ProcName from SysProcess Where MainProcName is null
GO

-- Kumulatif 2017 V.2.6 (KOSONG)
-- Kumulatif 2017 V.2.5


Update Claim Set SysUserID=PUserID Where SysUserID is null
GO

UPDATE TOC Set NOCANCELF=0 WHERE NOCANCELF IS NULL
GO

UPDATE RPART SET DOCNO=REINSURANCE.DOCNO FROM RPART, REINSURANCE WHERE REINSURANCE.RNO=RPART.RNO AND RPART.DOCNO IS NULL
GO
-- Kumulatif 2017 V.2.4
Update SysRequest Set DueDate=UserDate Where DueDate is null
go

-- Kumulatif 2017 V.2.3
Update Reinsurance Set TreatyInstallmentF=0 Where TreatyInstallmentF is null
GO
UPDATE TOC Set NOINPUTF=0 Where NOINPUTF IS NULL
go
-- Kumulatif 2017 V.2.2
Update RArrDet Set JPShare=0 Where JPShare is null
Update RArrDet Set JPComm=0 Where JPComm is null
GO

-- Kumulatif 2017 V.2.1
Update Request set RefCCYDate=Date Where RefCCYDate is null
go

update sysprocid set status=1 where procid like 'web%'
go

-- Kumulatif 2017 V.2.0

Update ISource Set Limit=0 from ISource WHere Limit is null
Update ISource Set Excess=0 from ISource WHere Excess is null
GO
Update fpart set OComm=0 where OComm is null
Update fpart set ACQCOST=0 where ACQCOST is null
go
Update FPARTDET set OComm=0 where OComm is null
go
UPDATE REINSURANCE SET CURRENCY=SYSTAB.CURRENCY FROM REINSURANCE, SYSTAB WHERE REINSURANCE.CURRENCY IS NULL
GO

Update MAP_REFERENCE SEt CreateProfileF=DumpProfileF Where CreateProfileF is null
GO
Update Exchange Set Rate_RC=0 Where Rate_RC is null
GO
Update Currency Set Rate_RC=0 Where Rate_RC is null 
GO
Update Exchange Set VRate_RC=0 Where VRate_RC is null
GO
Update Currency Set VRate_RC=0 Where VRate_RC is null 
GO

update TOP_FD set AmountPCT=0 where AmountPCT is null
go

UPDATE ACCASS SET DEPOSITF=0 Where DEPOSITF IS NULL
UPDATE ACCASS SET DEPOSITF=1 WHERE CODE='J'
go
Update Payor Set ScheduleF=0 Where ScheduleF is null
GO
UPDATE TOC SET TAXINVOICEF=0 WHERE TAXINVOICEF IS NULL
GO

Update PTClass set AutoInforceF=0 Where AutoInforceF is null
go

-- Kumulatif 2017 V.1.5 (KOSONG)

-- Kumulatif 2017 V.1.4

Update MAP_REFERENCE SEt CreateProfileF=DumpProfileF Where CreateProfileF is null
GO

-- Kumulatif 2017 V.1.3 (KOSONG)
-- Kumulatif 2017 V.1.2

-- REFRESH SETTINGAN SYSPROCESS
Update SysProcess Set ProcGroup='BC' from sysprocess where procname in ('UPLOAD_BC','UPLOAD_BE','UPLOAD_SC','UPLOAD_UP')
Update SysProcess Set ProcGroup='QC' from sysprocess where procname in ('Verify_BC','Verify_BE','VERIFY_UP','VERIFY_SC')
Update sysprocess set ProcGroup='SC' Where ProcName Like 'Auto%'
GO

-- Kumulatif 2017 V.1.1
update province set Description_1 = '' where Description_1 is null
GO

-- Kumulatif 2017 V.1.0

UPDATE REINSURANCE SET AAP=0 Where AAP IS NULL
UPDATE REINSURANCE SET AAP_1=0 Where AAP_1 IS NULL
GO

UPDATE RPART SET AAP=0 Where AAP IS NULL
UPDATE RPART SET AAP_1=0 Where AAP_1 IS NULL
go
Update RateTab Set SPeriod=0 Where SPeriod is null
GO
Update ICover Set EUnit='a.o.e' Where EUnit is null
go

update profile_income set corporatef = 0 WHERE corporatef IS NULL
update Profile_Incomesource set corporatef = 0 WHERE corporatef IS NULL
go

Update MAP_HEADER Set MapReferenceF=1 Where MapGroup in ('SC')
Update MAP_HEADER Set MapReferenceF=0 Where MapGroup Not in ('SC')
GO
-- Koreksi Bugs Claim Approval (Desktop), dimana User Approval ID tidak masuk, hal ini disebabkan karena terlewatkan fungsi proses Approval Limit karena otorisasi..


Update Claim Set AUserID=Admlink.LUserID
from Claim, ClaAss, Admlink
Where Admlink.AdmNo=ClaAss.AdmNo and Claim.CNO=ClaAss.CNO and Claim.AUserID=''
GO

--Koreksi Bugs NCDate pada Upload SC, dimana NCDate menjadi Today Date jika tidak diisikan
Update A Set NCDate=A.SDate from scheme_transaction S, Acceptance A Where A.ANO=S.ANO and S.NCDate=S.LDate
Update S Set NCDate=A.SDate from scheme_transaction S, Acceptance A Where A.ANO=S.ANO and S.NCDate=S.LDate
GO
Update Scheme_Master set ApplyMasterCAF=0 where ApplyMasterCAF is null
go

UPDATE ACCFD SET AMOUNTPCT=0 Where AMOUNTPCT IS NULL
go


--24 nov 2016 : Koreksi Bugs untuk Conjunction Polis Polis Individual pada Certificate yang mengakibatkan Polis Individual tersebut tidak memiliki data Payor..


IF NOT EXISTS(SELECT * FROM Payor )
BEGIN
insert into PAyor(ANO, ID, Address_1, Address_2, Address_3, WPC, Period, Installment, PolicyYearF, Discount, DiscAmount, Grace, GDIscount, DefaultPayorF)
Select A.ANO, P.ID, P.Address_1, P.Address_2, P.Address_3,0,0,0,0,0,0,0,0,1
from Acceptance A, Cover C, Profile P 
Where A.LANO=-1 and C.CNO=A.CNO and P.ID=C.PHolder and not Exists (Select ANO from Payor Where Payor.ANO=A.ANO)
end
go

UPDATE SysTab set AdjustmentPolicyDepositF=0 Where AdjustmentPolicyDepositF is null
go
UPDATE CLSAL SET GROSSAMOUNT=AMOUNT WHERE GROSSAMOUNT IS NULL
UPDATE CLSAL SET VAT=0 WHERE VAT IS NULL
UPDATE CLSAL SET TAX=0 WHERE TAX IS NULL
UPDATE CLSAL SET NETAMOUNT=AMOUNT WHERE NETAMOUNT IS NULL
GO
update Scheme_Transaction set TOTAL=0 where total is null
go
Update Request Set DueDate=Date from Request Where DueDate is null
go
UPDATE TOC Set VATBUSINESSF=0 Where VATBUSINESSF is null
go


--Cleansing SCript

update R1 Set Limit=Amount/(share/100), Excess=R2.Tamount-Amount/(share/100)
from RArrDet R1, RArrHeader R2 
Where R2.ANO=R1.ANO and R1.Limit<>0 and R1.Excess<>0 

Update R1 Set Limit=0, Excess=0
from RArrDet R1, RArrHeader R2 
Where R2.ANO=R1.ANO and R1.Limit<>0 and R1.Excess<=0 
GO


--PERBAIKAN INISIALISASI MAP_FIELD KARENA SALAH MEMBACA TYPE DATA
update MAP_FIELD set SpaceF=1 where FieldType='D'
GO


Update A Set CNO=MA.CNO
from Acceptance MA, Acceptance A
Where A.RegNo=MA.RegNo and A.PolicyNo=MA.PolicyNo and MA.PolicyNo<>'' and MA.RegNo<>'' AND MA.ANO = MA.LANO
and A.CNO<>MA.CNO
GO



UPDATE GENHTAB SET SEGMENTF=0 WHERE SEGMENTF IS NULL
go
UPDATE GENDTAB SET FLDCHGINF=1 WHERE FLDCHGINF IS NULL
go


Update GenHTab Set FLDLOWER='' WHERE FLDLOWER IS NULL
Update GenHTab Set FLDUPPER='' WHERE FLDUPPER IS NULL
GO

UPDATE ACCFD SET AMOUNTPCT=0 Where AMOUNTPCT IS NULL
go
Update MAP_HEADER Set MapReferenceF=1 Where MapGroup in ('SC')
Update MAP_HEADER Set MapReferenceF=0 Where MapGroup Not in ('SC')
go

-- INISIALISASI AUSERID APPROVAL CLAIM 

Update Claim Set AUserID=Admlink.LUserID
from Claim, ClaAss, Admlink
Where Admlink.AdmNo=ClaAss.AdmNo and Claim.CNO=ClaAss.CNO and Claim.AUserID=''
GO

--INISIALISASI NCDATE
Update A Set NCDate=A.SDate from scheme_transaction S, Acceptance A Where A.ANO=S.ANO and S.NCDate=S.LDate
Update S Set NCDate=A.SDate from scheme_transaction S, Acceptance A Where A.ANO=S.ANO and S.NCDate=S.LDate
GO



 insert into SysUserForm
select s.TYPE,f.fname,1,1,1,1,1,1
from SysUserType s, SysForm f
where f.FName in('ALLOWMULTIPLEREQUEST','ALLOWPAYMENTREQUEST','ALLOWRECEIPTREQUEST','ALLOWGROUPDISCOUNT','ALLOWDISPLAYALLTC')
and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
GO


--INISIALISASI PRIVILLEGE
insert into SysUserForm
select s.TYPE,f.fname,1,1,1,1,1,1
from SysUserType s, SysForm f
where f.FName in('ALLOWCHANGESOURCETYPE','ALLOWCHANGETC','ALLOWWPCEXEXPIRY','ALLOWCHANGERAOPTION',
'ALLOWCHANGEDATAOTHERUSER','ALLOWCLAIMREOPEN')
and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
GO



UPDATE TOC SET SECURITYNOF=0 WHERE SECURITYNOF IS NULL
GO
Update TOC Set DEFSTime='00:00', DEFETime='24:00' Where ExclusiveF=1
GO
Update TOC Set DEFSTime='12:00', DEFETime='12:00' Where ExclusiveF=0

GO

Update Acceptance Set STime='00:00', ETime='24:00' Where ExclusiveF=1
GO
Update Acceptance Set STime='12:00', ETime='12:00' Where ExclusiveF=0

GO
Update Payor Set NDiscount=0 Where NDiscount is null
Update Payor Set SLoading=0 Where SLoading is null
go

update PCalc set DDiscount=0 Where DDiscount is null
GO
update RCalc set DDiscount=0 Where DDiscount is null
GO

update ICalc set DDiscount=0 Where DDiscount is null
GO

UPDATE RCOVER SET DNO_EXT='' Where DNO_EXT IS NULL
UPDATE RCOVER SET DISCOUNT_EXT=0 Where DISCOUNT_EXT IS NULL
GO

Update ICover Set Currency_OC='' Where Currency_OC IS NULL
Update ICover Set Amount_OC=0 Where Amount_OC IS NULL
Update ICover Set Amount_AOE_OC=0 Where Amount_AOE_OC IS NULL
Update ICover Set SI_OC=0 Where SI_OC IS NULL
Update ICover Set Rate_OC=0 Where Rate_OC IS NULL
GO


--Create Temporary ..

Select Distinct Voucher.Voucher, VPattern.Account into #SL 
from nSL SL, nVoucher Voucher, VType, vPattern 
Where VType.VType=Voucher.VType and Voucher.Voucher=SL.Voucher and vPattern.VType=Voucher.VType 
and ((vpattern.debit=SL.Hint and Voucher.DebtorF=1) or (vpattern.credit=SL.Hint and Voucher.CreditorF=1))
and vpattern.Debit+vpattern.Credit not in (-11,-12)
and SL.Account<>vPattern.Account 
and (VType.TaxF=1 or Voucher.InvestmentF=1 or Voucher.SL_Tag<>0)

--Update nSL
Update nSL Set Account=#SL.Account from nSL, #SL Where #SL.Voucher=nSL.Voucher

drop table #SL


GO

UPDATE ACCEPTANCE SET TOC=COVER.TOC FROM ACCEPTANCE, COVER
WHERE COVER.CNO=ACCEPTANCE.CNO 
AND COVER.TOC IN(SELECT TOC FROM TOC)
AND (ACCEPTANCE.TOC IS NULL or ACCEPTANCE.TOC='')
go

UPDATE POLICYTYPE SET MULTITOCF=0 WHERE MULTITOCF IS NULL
GO

UPDATE RATECON Set ProgressiveF=0 Where ProgressiveF is null
GO

UPDATE Scheme_Additional Set ProgressiveF=0 Where ProgressiveF is null
GO


Update Request Set Status='R' from Request Where Status='' 
GO
Update Request Set Status='P' from Request Where Voucher<>'' 
GO

Update TOC set InvResult=0 Where InvResult is null
Update TOC set InvResultOp=0 Where InvResultOp is null
GO
Update Reinsurance Set ConsortiumF=0 Where ConsortiumF is null
GO
Update Asset Set pAsset=PAsset.Asset
from Asset, pVoucher, Asset pAsset
Where Asset.Asset=pVoucher.Asset and SL_Cat='F' and pVoucher.Remarks Like '%Asset ID : '''+pAsset.Asset+'%' and pAsset.Asset<>Asset.Asset
GO


UPDATE RATECON Set ProgressiveF=0 Where ProgressiveF is null
GO

UPDATE Scheme_Additional Set ProgressiveF=0 Where ProgressiveF is null
GO

Update ProAcc Set Remarks='' where Remarks is null
go
Update RateTab Set SIBasedID=0 Where SIBasedID is null
GO