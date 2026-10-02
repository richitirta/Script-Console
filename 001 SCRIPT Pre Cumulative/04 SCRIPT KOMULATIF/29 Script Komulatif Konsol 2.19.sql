DROP FUNCTION TNYD_PROCESS
GO
CREATE FUNCTION TNYD_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS @ACCLINK TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(50), Currency varchar(10), Subject varchar(10), Remarks varchar(Max), Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float, Amount_5 FLoat, Amount Float, Rate Float, Rate_RC Float)

BEGIN  
     

declare @Voucher table(Voucher varchar(20), DebtorF Bit)
insert into @Voucher(Voucher, DebtorF)
Select Voucher.Voucher, Voucher.DebtorF as DebtorF
from Admlink, nVoucher Voucher, Profile
Where Voucher.Voucher=Admlink.Voucher and Voucher.Date<=@P_Date and ((Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC)<>0 or Voucher.PDate>=@P_Date)
and Profile.ID=Admlink.A_ID 
--Add Filter here (Outward Treaty)
and Admlink.Type in ('QS','QP','S1','S2','S3')
and Admlink.Subject in ('Premium','Claim')
and Admlink.Date<=@P_Date

declare @Payment table(Voucher varchar(20), Payment_CC Float)
insert into @Payment(Voucher, Payment_CC)
Select pSL.Doc_No as Voucher, Sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)) as Payment_CC 
from pSL, pVoucher, @Voucher V 
Where pSL.PaymentF=1 and V.Voucher=pSL.Doc_No and pVoucher.Voucher=pSL.Voucher and pVoucher.Date<=@P_Date
Group By pSL.Doc_No

insert into @Acclink
select V.Branch, V.Voucher as DocNo, V.RefNo, @P_Date as Date, V.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, V.Remarks as Remarks,  
'Amount_1'= Case When V.Subject='Premium' Then Case When V.Payment_CC>V.AmountDue Then V.Amount-V.Payment_CC Else V.Amount-V.AmountDue End*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End) else 0 end,
'Amount_2'= Case When V.Subject='Claim' Then Case When V.Payment_CC>V.AmountDue Then V.Amount-V.Payment_CC Else V.Amount-V.AmountDue End*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End) else 0 end,
'Amount_3'=0,
'Amount_4'=0,
'Amount_5'=0,
'Amount'= Case When V.Payment_CC>V.AmountDue Then V.Amount-V.Payment_CC Else V.Amount-V.AmountDue End*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
0 as Rate,
0 as Rate_RC
from 
(
	Select
	V.Voucher, 
	V.DebtorF,
	A.Branch,
	A.RefNo, 
	A.Code,
	A.Remarks,
	A.ISType,
	A.Currency,
	A.Subject,
	(
	Case When Voucher.Installment=0 and datediff(Month,Voucher.DueDate,@P_Date)>=0 Then A.AMOUNT Else 0 End
	+ Case When Voucher.INSTALLMENT=1 and datediff(Month,Voucher.DueDate_1,@P_Date)>=0 Then A.AMOUNTDUE_1 Else 0 End
	+ Case When Voucher.INSTALLMENT=2 and datediff(Month,Voucher.DueDate_2,@P_Date)>=0 Then A.AMOUNTDUE_2 Else 0 End 
	+ Case When Voucher.INSTALLMENT=3 and datediff(Month,Voucher.DueDate_3,@P_Date)>=0 Then A.AMOUNTDUE_3 Else 0 End 
	+ Case When Voucher.INSTALLMENT=4 and datediff(Month,Voucher.DueDate_4,@P_Date)>=0 Then A.AMOUNTDUE_4 Else 0 End 
	+ Case When Voucher.INSTALLMENT=5 and datediff(Month,Voucher.DueDate_5,@P_Date)>=0 Then A.AMOUNTDUE_5 Else 0 End 
	+ Case When Voucher.INSTALLMENT=6 and datediff(Month,Voucher.DueDate_6,@P_Date)>=0 Then A.AMOUNTDUE_6 Else 0 End 
	+ Case When Voucher.INSTALLMENT=7 and datediff(Month,Voucher.DueDate_7,@P_Date)>=0 Then A.AMOUNTDUE_7 Else 0 End 
	+ Case When Voucher.INSTALLMENT=8 and datediff(Month,Voucher.DueDate_8,@P_Date)>=0 Then A.AMOUNTDUE_8 Else 0 End 
	+ Case When Voucher.INSTALLMENT=9 and datediff(Month,Voucher.DueDate_9,@P_Date)>=0 Then A.AMOUNTDUE_9 Else 0 End 
	+ Case When Voucher.INSTALLMENT=10 and datediff(Month,Voucher.DueDate_10,@P_Date)>=0 Then A.AMOUNTDUE_10 Else 0 End 
	+ Case When Voucher.INSTALLMENT=11 and datediff(Month,Voucher.DueDate_11,@P_Date)>=0 Then A.AMOUNTDUE_11 Else 0 End 
	+ Case When Voucher.INSTALLMENT=12 and datediff(Month,Voucher.DueDate_12,@P_Date)>=0 Then A.AMOUNTDUE_12 Else 0 End 
	+ Case When Voucher.INSTALLMENT=13 and datediff(Month,Voucher.DueDate_13,@P_Date)>=0 Then A.AMOUNTDUE_13 Else 0 End 
	+ Case When Voucher.INSTALLMENT=14 and datediff(Month,Voucher.DueDate_14,@P_Date)>=0 Then A.AMOUNTDUE_14 Else 0 End 
	+ Case When Voucher.INSTALLMENT=15 and datediff(Month,Voucher.DueDate_15,@P_Date)>=0 Then A.AMOUNTDUE_15 Else 0 End 
	+ Case When Voucher.INSTALLMENT=16 and datediff(Month,Voucher.DueDate_16,@P_Date)>=0 Then A.AMOUNTDUE_16 Else 0 End 
	+ Case When Voucher.INSTALLMENT=17 and datediff(Month,Voucher.DueDate_17,@P_Date)>=0 Then A.AMOUNTDUE_17 Else 0 End 
	+ Case When Voucher.INSTALLMENT=18 and datediff(Month,Voucher.DueDate_18,@P_Date)>=0 Then A.AMOUNTDUE_18 Else 0 End 
	+ Case When Voucher.INSTALLMENT=19 and datediff(Month,Voucher.DueDate_19,@P_Date)>=0 Then A.AMOUNTDUE_19 Else 0 End 
	+ Case When Voucher.INSTALLMENT=20 and datediff(Month,Voucher.DueDate_20,@P_Date)>=0 Then A.AMOUNTDUE_20 Else 0 End 
	+ Case When Voucher.INSTALLMENT=21 and datediff(Month,Voucher.DueDate_21,@P_Date)>=0 Then A.AMOUNTDUE_21 Else 0 End 
	+ Case When Voucher.INSTALLMENT=22 and datediff(Month,Voucher.DueDate_22,@P_Date)>=0 Then A.AMOUNTDUE_22 Else 0 End 
	+ Case When Voucher.INSTALLMENT=23 and datediff(Month,Voucher.DueDate_23,@P_Date)>=0 Then A.AMOUNTDUE_23 Else 0 End 
	+ Case When Voucher.INSTALLMENT=24 and datediff(Month,Voucher.DueDate_24,@P_Date)>=0 Then A.AMOUNTDUE_24 Else 0 End 	
	)*(Case When V.DebtorF=1 Then 1 else -1 end)
	as AmountDue,
	A.Amount*(Case When V.DebtorF=1 Then 1 else -1 end) as Amount,
	P.Payment_CC*(Case When V.DebtorF=1 Then 1 else -1 end) as Payment_CC 
	from @Voucher V
	Left Join @Payment P on (P.Voucher=V.Voucher)
	Inner Join nVoucher Voucher on (Voucher.Voucher=V.Voucher)
	Inner Join Admlink A on (A.Voucher=V.Voucher)
) V, fn_Exchange(dateadd(day,1,@P_Date)) Currency, SysTab
Where Currency.Currency=V.Currency
and Case When V.Payment_CC>V.AmountDue Then V.Amount-V.Payment_CC Else V.Amount-V.AmountDue End>0

insert into @Acclink
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code, @P_Type as Type, A.Currency, 'REVERSAL' as Subject, A.Remarks,            
 -Amount_1 as Amount_1,            
 -Amount_2 as Amount_2,            
 -Amount_3 as Amount_3,            
 -Amount_4 as Amount_4,            
 -Amount_5 as Amount_5,            
 -Amount as Amount,  
 mVoucher.Rate,
 mVoucher.Rate_RC      
from AccLink A, mVoucher          
Where A.Type='TD' and Month(A.Date)=Month(@P_PEDate) and Year(A.Date)=Year(@P_PEDate) and mVoucher.Voucher=A.Voucher       
and A.Subject<>'REVERSAL' 

Return
END

go

DROP FUNCTION AFDA_PROCESS
GO
CREATE FUNCTION AFDA_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS @ACCLINK TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(50), Currency varchar(10), Subject varchar(10), Remarks varchar(Max), Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float, Amount_5 FLoat, Amount Float, Rate Float, Rate_RC Float)

BEGIN  
     

Declare @P_Lapse int

Select @P_Lapse=12	-- in Months

declare @Voucher table(Voucher varchar(20), DebtorF Bit)
insert into @Voucher(Voucher, DebtorF)
Select Voucher.Voucher, Voucher.DebtorF as DebtorF
from Admlink, nVoucher Voucher, VOUCHER_AMOUNTDUE(@P_Date) V, Profile
Where Voucher.Voucher=Admlink.Voucher and Voucher.Date<=@P_Date and ((Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC)<>0 or Voucher.PDate>=@P_Date)
and Profile.ID=Admlink.A_ID and V.Voucher=Voucher.Voucher
--Add Filter here
and datediff(Month,V.DueDate,@P_Date)>@P_Lapse
and Admlink.Type in ('DI','IC','CF','JP','IR','IT','IX')
and Admlink.Subject='Premium'
and Profile.CGroup not in ('PERTAMINA')

declare @Payment table(Voucher varchar(20), Payment_CC Float)
insert into @Payment(Voucher, Payment_CC)
Select pSL.Doc_No as Voucher, Sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)) as Payment_CC 
from pSL, pVoucher, @Voucher V 
Where pSL.PaymentF=1 and V.Voucher=pSL.Doc_No and pVoucher.Voucher=pSL.Voucher and pVoucher.Date<=@P_Date
Group By pSL.Doc_No

insert into @Acclink
select V.Branch, V.Voucher as DocNo, V.RefNo, @P_Date as Date, V.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, V.Remarks as Remarks,  
'Amount_1'= Case When V.ISType in ('I','L','C') and V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_2'= Case When V.ISType Not In ('I','L','C') and V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_3'=0,
'Amount_4'=0,
'Amount_5'=0,
'Amount'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
0 as Rate,
0 as Rate_RC
from 
(
	Select
	V.Voucher, 
	V.DebtorF,
	A.Branch,
	A.RefNo, 
	A.Code,
	A.Remarks,
	A.ISType,
	A.Currency,
	(
	Case When Voucher.Installment=0 and datediff(Month,Voucher.DueDate,@P_Date)>@P_Lapse Then A.AMOUNT Else 0 End
	+ Case When Voucher.INSTALLMENT=1 and datediff(Month,Voucher.DueDate_1,@P_Date)>@P_Lapse Then A.AMOUNTDUE_1 Else 0 End
	+ Case When Voucher.INSTALLMENT=2 and datediff(Month,Voucher.DueDate_2,@P_Date)>@P_Lapse Then A.AMOUNTDUE_2 Else 0 End 
	+ Case When Voucher.INSTALLMENT=3 and datediff(Month,Voucher.DueDate_3,@P_Date)>@P_Lapse Then A.AMOUNTDUE_3 Else 0 End 
	+ Case When Voucher.INSTALLMENT=4 and datediff(Month,Voucher.DueDate_4,@P_Date)>@P_Lapse Then A.AMOUNTDUE_4 Else 0 End 
	+ Case When Voucher.INSTALLMENT=5 and datediff(Month,Voucher.DueDate_5,@P_Date)>@P_Lapse Then A.AMOUNTDUE_5 Else 0 End 
	+ Case When Voucher.INSTALLMENT=6 and datediff(Month,Voucher.DueDate_6,@P_Date)>@P_Lapse Then A.AMOUNTDUE_6 Else 0 End 
	+ Case When Voucher.INSTALLMENT=7 and datediff(Month,Voucher.DueDate_7,@P_Date)>@P_Lapse Then A.AMOUNTDUE_7 Else 0 End 
	+ Case When Voucher.INSTALLMENT=8 and datediff(Month,Voucher.DueDate_8,@P_Date)>@P_Lapse Then A.AMOUNTDUE_8 Else 0 End 
	+ Case When Voucher.INSTALLMENT=9 and datediff(Month,Voucher.DueDate_9,@P_Date)>@P_Lapse Then A.AMOUNTDUE_9 Else 0 End 
	+ Case When Voucher.INSTALLMENT=10 and datediff(Month,Voucher.DueDate_10,@P_Date)>@P_Lapse Then A.AMOUNTDUE_10 Else 0 End 
	+ Case When Voucher.INSTALLMENT=11 and datediff(Month,Voucher.DueDate_11,@P_Date)>@P_Lapse Then A.AMOUNTDUE_11 Else 0 End 
	+ Case When Voucher.INSTALLMENT=12 and datediff(Month,Voucher.DueDate_12,@P_Date)>@P_Lapse Then A.AMOUNTDUE_12 Else 0 End 
	+ Case When Voucher.INSTALLMENT=13 and datediff(Month,Voucher.DueDate_13,@P_Date)>@P_Lapse Then A.AMOUNTDUE_13 Else 0 End 
	+ Case When Voucher.INSTALLMENT=14 and datediff(Month,Voucher.DueDate_14,@P_Date)>@P_Lapse Then A.AMOUNTDUE_14 Else 0 End 
	+ Case When Voucher.INSTALLMENT=15 and datediff(Month,Voucher.DueDate_15,@P_Date)>@P_Lapse Then A.AMOUNTDUE_15 Else 0 End 
	+ Case When Voucher.INSTALLMENT=16 and datediff(Month,Voucher.DueDate_16,@P_Date)>@P_Lapse Then A.AMOUNTDUE_16 Else 0 End 
	+ Case When Voucher.INSTALLMENT=17 and datediff(Month,Voucher.DueDate_17,@P_Date)>@P_Lapse Then A.AMOUNTDUE_17 Else 0 End 
	+ Case When Voucher.INSTALLMENT=18 and datediff(Month,Voucher.DueDate_18,@P_Date)>@P_Lapse Then A.AMOUNTDUE_18 Else 0 End 
	+ Case When Voucher.INSTALLMENT=19 and datediff(Month,Voucher.DueDate_19,@P_Date)>@P_Lapse Then A.AMOUNTDUE_19 Else 0 End 
	+ Case When Voucher.INSTALLMENT=20 and datediff(Month,Voucher.DueDate_20,@P_Date)>@P_Lapse Then A.AMOUNTDUE_20 Else 0 End 
	+ Case When Voucher.INSTALLMENT=21 and datediff(Month,Voucher.DueDate_21,@P_Date)>@P_Lapse Then A.AMOUNTDUE_21 Else 0 End 
	+ Case When Voucher.INSTALLMENT=22 and datediff(Month,Voucher.DueDate_22,@P_Date)>@P_Lapse Then A.AMOUNTDUE_22 Else 0 End 
	+ Case When Voucher.INSTALLMENT=23 and datediff(Month,Voucher.DueDate_23,@P_Date)>@P_Lapse Then A.AMOUNTDUE_23 Else 0 End 
	+ Case When Voucher.INSTALLMENT=24 and datediff(Month,Voucher.DueDate_24,@P_Date)>@P_Lapse Then A.AMOUNTDUE_24 Else 0 End 	
	)*(Case When V.DebtorF=1 Then 1 else -1 end)
	as AmountDue,
	P.Payment_CC*(Case When V.DebtorF=1 Then 1 else -1 end) as Payment_CC 
	from @Voucher V
	Left Join @Payment P on (P.Voucher=V.Voucher)
	Inner Join nVoucher Voucher on (Voucher.Voucher=V.Voucher)
	Inner Join Admlink A on (A.Voucher=V.Voucher)
) V, fn_Exchange(dateadd(day,1,@P_Date)) Currency, SysTab
Where Currency.Currency=V.Currency
and Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end>0

insert into @Acclink
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code, @P_Type as Type, A.Currency, 'REVERSAL' as Subject, A.Remarks,            
 -Amount_1 as Amount_1,            
 -Amount_2 as Amount_2,            
 -Amount_3 as Amount_3,            
 -Amount_4 as Amount_4,            
 -Amount_5 as Amount_5,            
 -Amount as Amount,  
 mVoucher.Rate,
 mVoucher.Rate_RC      
from AccLink A, mVoucher          
Where A.Type='AD' and Month(A.Date)=Month(@P_PEDate) and Year(A.Date)=Year(@P_PEDate) and mVoucher.Voucher=A.Voucher       
and A.Subject<>'REVERSAL' 

Return
END

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
ALTER TABLE dbo.AdmLink ADD
	Rate_OC float(53) NULL,
	Currency_OC varchar(5) NULL
GO
ALTER TABLE dbo.AdmLink SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--tuning script
Alter Table RDOCLIST Drop Constraint FK_RDOCLIST_Request
GO
Alter Table SL_Request Drop Constraint FK_SL_Request_Request
GO
Alter Table RequestPIC Drop Constraint FK_RequestPIC_Request
GO
Alter Table Request drop constraint I_Request
GO
Create Unique Index I_Request on Request(Request)
GO
ALTER TABLE RDOCLIST WITH NOCHECK ADD  CONSTRAINT [FK_RDOCLIST_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request]) ON UPDATE CASCADE ON DELETE CASCADE
GO
ALTER TABLE SL_Request WITH NOCHECK ADD  CONSTRAINT [FK_SL_Request_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request]) ON UPDATE CASCADE ON DELETE CASCADE
GO
ALTER TABLE RequestPic WITH NOCHECK ADD  CONSTRAINT [FK_RequestPic_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request]) ON UPDATE CASCADE ON DELETE CASCADE
GO
Create Index I_Request_Voucher on Request(Voucher)
GO
Create Index I_SL_Request_Account on SL_Request(Account)
GO
Create Index I_SL_Request_Doc_No on SL_Request(Doc_No)
GO
Create Index I_SL_Request_Request on SL_Request(Request)
GO
Create Index I_SL_Request_Request_DocNo_SortNo on SL_Request(Request, Doc_No, SortNo)
go
drop index nSL.I_nSL_Doc_No_pVoucher
GO
Create Index I_nSL_pVoucher on nSL(PVoucher)
GO
Create Index I_SL_Doc_No on nSL(Doc_No)
GO
drop index pSL.I_pSL_Doc_No_pVoucher
GO
drop index pSL.I_pSL_Voucher_Doc_No_SortNo
GO
Create Index I_pSL_pVoucher on pSL(PVoucher)
go

--27 okt 2017
insert into SysForm(FName, Description, FCOde)
Select 'FORCECHECKCLAIMREFNO', 'Force Check Duplicate Claim Reference No ','ACTIVITIES'

go

DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.
NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.REFNO, ACCEPTANCE.ANO DESC     
go
--VERSIONING
insert into versioning
select '2017 V.2.19.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
