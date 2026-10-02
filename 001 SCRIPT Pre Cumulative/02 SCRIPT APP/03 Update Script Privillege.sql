
insert into sysform(FName,Description, FCode) Select 'ALLOWOVERPAID', 'Allow Overpaid Transaction (FA)','ACTIVITIES'
insert into sysform(FName,Description, FCode) Select 'ALLOWCOMPENSATION', 'Allow Compensating Transaction (FA)','ACTIVITIES'
insert into sysform(FName,Description, FCode) Select 'ALLOWOVERBOOKING', 'Allow Overbooking Transaction (FA)','ACTIVITIES'


insert into sysform(fname, Description, fcode) Select 'ALLOWQRYALLTOC', 'Allow Query All Sub-Class (UW)','ACTIVITIES'
GO



insert into Sysform(FName, Description, FCode) Select 'PROFILE_PHOLDER', 'Changing Profile Policy Holder', 'ACTIVITIES'


--harry

--setto
insert into Sysform(FName, Description, FCode) Select 'RequestDocDlg', 'Document Upload Dialog (FA)','Finance'
GO
insert into Sysform(FName, Description, FCode) Select 'RequestDocFrm', 'Document Upload List (FA)','Finance'
GO
insert into Sysform(FName, Description, FCode) Select 'ALLOWZEROUJROH', 'Allow Entry zero for Ujroh Fee', 'ACTIVITIES'
GO
insert into Sysform(FName, Description, FCode) Select 'ALLOWCHANGEREFNO', 'Allow Change Reference No', 'ACTIVITIES'
GO
Insert into Sysform(FNAme, Description, Fcode) Select 'ALLOWENDORSEALPOLICY', 'Allow Endorse Auto Lapse Policy (UW)','ACTIVITIES'
go
insert into Sysform(FName, Description, FCode) Select 'ALLOWCHANGEBOOKDATE', 'Allow Change Booking Date','ACTIVITIES'
go
insert into sysform select 'CGROUPFRM','Company Group','SETUP',0
GO
insert into sysform select 'SCGROUPFRM','Sub Company Group','SETUP',0
GO
insert into sysform select 'CGROUPLISTFRM','Company Group List','SETUP',0
GO
insert into sysform select 'SCGROUPLISTFRM','Sub Company Group List','SETUP',0
GO
Insert into SysForm(FName, Description, FCode) Select 'ALLOWEXCEEDMAXGRACE', 'Allow Exceed Max Grace Period','ACTIVITIES'
GO
Insert into SysForm(FName, Description, FCode) Select 'ALLOWCREXCEEDLT', 'Allow Claim Report Exceed Max Lead Time','ACTIVITIES'
GO
Insert into SysForm(FName, Description, FCode) Select 'ALLOWCSEXCEEDLT', 'Allow Claim Register Exceed Max Lead Time','ACTIVITIES'
GO
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGEGRACEPRD','Allow Change Grance Period','ACTIVITIES'
GO
insert into sysform(FName, Description, FCode) Select 'FORCEFILLVYGCOUNTRY','Force Fill Voyage From Country Table','ACTIVITIES'
GO
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGERATEDISC','Allow Change Rate Discount (UW)','ACTIVITIES'
go

--meli

--INSERT INTO SYSFORM(FNAME,DESCRIPTION, FCODE) SELECT 'ALLOWCLAIMTOTALLOSS','Allow Claim Total Loss (Claim)','ACTIVITIES'

insert into SysProcess (ProcName,ProcGroup,TimeOut,StartTime,EndTime,Schedule,StartDay,EndDay,FreqDay,ScheduleF,ExecCheckF)
select 'AUTOINFORCE_PROCESS','SC',0,'12:00','13:00',0,1,31,0,0,0
Insert into Sysform(FNAme, Description, Fcode) Select 'ALLOWAUTOINFORCE','Allow Auto Inforce (UW)','ACTIVITIES'
Insert into Sysform(FNAme, Description, Fcode) Select 'ALLOWAUTOPRINT','Allow Auto Print (UW/CL)','ACTIVITIES'
insert into BRRule(TOC, Branch, BizMapID, ExtraCost_1, ExtraCost_2, ExtraCost_3, ExtraCost_4, ExtraCost_5,  ExtraCost_6, ExtraCost_7, Last_Opr, Last_Update)
Select Distinct TOC, Branch, '<All>' as BizMapID, ExtraCost_1, ExtraCost_2, ExtraCost_3, ExtraCost_4, ExtraCost_5,  ExtraCost_6, ExtraCost_7, Last_Opr, Last_Update from #B2
go
insert into BRRuleMin(TOC, Branch, BizMapID, Currency, MPremium)
Select Distinct TOC, Branch, '<All>', Currency, MPremium from #B1
go
insert into profile_income select '1-10 juta', '1-10 juta', 1
insert into profile_income select '> 10-25 juta', '> 10-25 juta', 1
insert into profile_income select '> 10-25 juta', '> 10-25 juta', 1
insert into profile_income select '> 25-50 juta', '> 25-50 juta', 1
insert into profile_income select '> 50-100 juta', '> 50-100 juta', 1
insert into profile_income select '> 100 juta', '> 100 juta', 1
insert into profile_incomesource select 'Hasil Usaha', 'Hasil Usaha', 1
insert into profile_incomesource select 'Gaji Bulanan', 'Gaji Bulanan', 1
insert into profile_incomesource select 'Wirausaha', 'Wirausaha', 1
insert into profile_incomesource select 'Lain-lain', 'Lain-lain', 1
insert into sysform(FName, Description, FCode) Select 'SHARIASURPLUSPROCESS', 'Allow Process Sharia Surplus Calc (FA)','ACTIVITIES'
insert into sysform(FName, Description, FCode) Select 'ALLOWPASSAPPLIMIT', 'Allow ByPass Approval Limit (UW)','ACTIVITIES'
GO

--andreas
insert into sysform(FName, Description, FCode) Select 'SHARIASURPLUSPROCESS', 'Allow Process Sharia Surplus Calc (FA)','ACTIVITIES'
insert into sysform(FName, Description, FCode) Select 'ALLOWPASSAPPLIMIT', 'Allow ByPass Approval Limit (UW)','ACTIVITIES'

--22 April 2013
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGEBANKACC', 'Allow Change Bank Account (FA)','ACTIVITIES'

--23 April 2013
insert into SysProcess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF)

--31 May 2013

--Penambahan Activities autoPaymentRequest_Process

insert into sysprocess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF) Select 'AUTOPAYMENTREQUEST_PROCESS','SC',0,'00:00','24:00',0,1,31,0,1
GO

--4 June 2013

--Penambahan Activities AllowPDueGTFDue - Allow Payor Due Greater Than Facultative Due

insert into sysform(FName, Description, FCode)

--Penambahan Privileges Exceding object Valuation
insert into sysform(FName, Description, FCode) Select 'EXCEEDINGVALUATION','Allow Exceeding Object Valuation', 'ACTIVITIES'
GO

--23 April 2013
INSERT INTO sysprocess
Select 'AutoCreate_WithHoldingTax','SC',0,'00:00','24:00',1,1,31,0,0
go
--4 June 2013

--Penambahan Activities AllowPDueGTFDue - Allow Payor Due Greater Than Facultative Due
INSERT INTO sysform
Select 'AllowPDueGTFDue','Allow Payor Due Greater Than Fac Due', 'ACTIVITIES',0
GO

--toro
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update)
select * from #docstat
go

ALTER TABLE DocStat ALTER COLUMN PURPOSE varchar (10)
GO
ALTER TABLE DocStat ALTER COLUMN COLTYPE varchar (10)
GO

Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL01','No Telp tertanggung','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL02','Tanggal inspector melakukan survey','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL03','Masalah yang dihadapi Inspector selama pengumpulan berkas','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL04','Tanggal Inspector menerima berkas lengkap','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL05','Tanggal SPK diprint','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL06','Tanggal Inspector mengirimkan berkas ke pemegang limit ( Insp Coord/Service Head/LAD)','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL07','Tanggal Inspector mengirimkan berkas ke Claim Admin','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL08','Tanggal Claim Admin menerima berkas dari Inspector','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL09','Tanggal Claim Admin mengecek kelengkapan berkas dari Inspector','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL10','Masalah yang ditemukan pada berkas dari Inspector','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL11','Tanggal berkas lengkap di Claim Admin','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL12','Tanggal order part ke Supplier','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL13','Masalah dalam pengorderan part','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL14','Tanggal part di suplay','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL15','Tanggal mengirimkan SK investigasi','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL16','Tanggal LHS investigasi diterima','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL17','Masalah dalam proses investigasi','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL18','Tanggal menerima estimasi dari bengkel','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL19','Tanggal estimasi disetujui oleh pihak bengkel dan Adira','CI',1,'CARE',GetDate(),'CLAIM','DATe'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL20','Masalah yang dihadapi selama proses estimasi','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL21','Tanggal wreck diterima','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL22','Masalah yang dihadapi dalam menangani wreck','CI',1,'CARE',GetDate(),'CLAIM','TEXT'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL23','Tanggal menerima kuintansi (Casco) dari bengkel','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL24','Tanggal menerima kuintansi (TPL) dari bengkel','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL25','Tanggal menerima kuintansi (Supplier) dari supply part','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL26','Tanggal menerima kuintansi (Investigasi) dari Investigator','CI',1,'CARE',GetDate(),'CLAIM','DATE'
Insert into DocStat(StatID, Description, Class, AllowedF, Last_Opr, Last_Update, Purpose, ColType) Select 'CL27','Keterangan tambahan','CI',1,'CARE',GetDate(),'CLAIM','TEXT'

--Penambahan Privilege payment Due
insert into Sysform(FName, Description, FCode) Select 'ALLOWCHANGECLMDUE',	'Allow Change Claim Payment Due','ACTIVITIES'

--Penambahan Activities ALLOWINDOCUMENT untuk Allow Incomplete Document
Insert into SysForm(FName, Description, FCode) Values('ALLOWINDOCUMENT','Allow Incomplete Document','ACTIVITIES')
GO

--28 November 2014 : Penambahan Auto Process => AUTOCLAIM_CLOSE untuk melakukan proses Close Claim secara otomatis jika sudah outstanding dalam Lapse 30 Hari 
insert into SysProcess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF)
Select 'AUTOCLAIM_CLOSE','SC',0,'00:00','24:00',0,1,31,0,0
go

--1 December 2014 : Penambahan Activities - Profile_Branch
insert into SysForm(FName, Description, FCode) Select 'PROFILE_BRANCH', 'Changing Profile Branch','ACTIVITIES'
go

-- 2014 v.4 k.2
insert into sysform select 'CGROUPFRM','Company Group','SETUP',0
insert into sysform select 'SCGROUPFRM','Sub Company Group','SETUP',0
insert into sysform select 'CGROUPLISTFRM','Company Group List','SETUP',0
insert into sysform select 'SCGROUPLISTFRM','Sub Company Group List','SETUP',0


--Penambahan Activities - 'ALLOWEXCEEDMAXGRACE'-Exceed Max Grace, 'ALLOWCREXCEEDLT'-Claim Report lead Time, dan 'ALLOWCSEXCEEDLT'-Claim Register Lead Time
Insert into SysForm(FName, Description, FCode)
Select 'ALLOWEXCEEDMAXGRACE', 'Allow Exceed Max Grace Period','ACTIVITIES'

Insert into SysForm(FName, Description, FCode)
Select 'ALLOWCREXCEEDLT', 'Allow Claim Report Exceed Max Lead Time','ACTIVITIES'

Insert into SysForm(FName, Description, FCode)
Select 'ALLOWCSEXCEEDLT', 'Allow Claim Register Exceed Max Lead Time','ACTIVITIES'

--Penambaha privillege ALLOWCHANGEGRACEPRD
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGEGRACEPRD','Allow Change Grance Period','ACTIVITIES'

--Penambaha privillege FORCEFILLVYGCOUNTRY
insert into sysform(FName, Description, FCode) Select 'FORCEFILLVYGCOUNTRY','Force Fill Voyage From Country Table','ACTIVITIES'
GO

--19 March 2015 : Penambahan Activities ALLOWCHANGERATEDISC untuk otorisasi merubah Rate Discount
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGERATEDISC','Allow Change Rate Discount (UW)','ACTIVITIES'
go

--27 March 2015 : Penambahan Activities ALLOWCHANGEBOOKDATE untuk otorisasi dimana kolom tanggal pembukuan bisa diubah 
insert into Sysform(FName, Description, FCode) Select 'ALLOWCHANGEBOOKDATE', 'Allow Change Booking Date','ACTIVITIES'
go



--dwii

insert into Balance_Type values('ST','Starting Balance Of Period')
insert into Balance_Type values('YD','Year To Date Nominal From Month-1 To End Of Period')
insert into Balance_Type values('PL','Total Nominal Of Ending Balance Within Period or Profit/Loss Within Period')
insert into Balance_Type values('TM','Total Nominal Of Ending Balance From Month-1 To End Of Period')
insert into Balance_Type values('BS','Starting Balance Of Next Period or Balance Sheet')
insert into Balance_Type values('CT','Total CT Nominal Within Period')
insert into Balance_Type values('BC','Total Nominal Of CT Budget Within Period')
insert into Balance_Type values('BP','Total Nominal Of Budget Within Period')
insert into Balance_Type values('YB','Total Nominal Of Budget From Month-1 To End Of Period')
insert into Balance_Type values('AC','Total Nominal By Account Classification')
insert into Balance_Type values('QS','User Defined Query')
insert into Balance_Type values('BY','Budget This Year')


--17 July 2013

--Penambahan Activities 'ALLOWCHANGEUJROH' untuk otorisasi apakah diperbolehkan merubah Ujroh Fee di Polis
insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGEUJROH', 'Allow Change Ujroh Fee', 'ACTIVITIES'


--3 October 2013 - Penambahan Activites ALLOWCREXCEEDLT untuk otorisasi pemrosesan claim bisa melebih parameter lead time (CRDays) yang sudah disetting
insert into sysform(FName, Description, FCode) Select 'ALLOWCREXCEEDLT','Allow Claim Report Exceeding Lead Time', 'ACTIVITIES'


--Penambahan Privillege terkait OJK
insert into sysform(FName, Description, FCode) 
Select 'ALLOWPAYORDISCOUNT', 'Allow Change Payor Discount (PAYOR)','ACTIVITIES'
go
insert into sysform(FName, Description, FCode) 
Select 'ALLOWCHANGEDEFDED', 'Allow Change Default Deductible','ACTIVITIES'
GO


--dwii 2
insert into sysform(FName, Description, FCode) Select 'FORCEFILLREFNO','Force Fill Reference No', 'ACTIVITIES'
GO


--29 July 2015 :Penambahana Otorisasi ALLOWCHANGESOURCE untuk Otorisasi perubahan komponen2 POlicy Source a.l. Segment/MO/Policy Holder/Agent/Broker

insert into Sysform (Fname, Description, FCode) Select 'ALLOWCHANGESOURCE','Allow Change Source-Segment/MO/Policy Holder/Agent/Broker (UW/MKT)','ACTIVITIES'


--12 August 2015 :Penambahan Activities FORCEFILLREASON, FORCEFILLASSESSOR, FORCEFILLSURVEYOR, INFORCEBATCH

insert into sysform(FName, Description, FCode) Select 'FORCEFILLREASON','Force Fill Reason','ACTIVITIES'
insert into sysform(FName, Description, FCode) Select 'FORCEFILLINSURVEYOR','Force Fill Internal Surveyor','ACTIVITIES'
insert into sysform(FName, Description, FCode) Select 'FORCEFILLINASSESSOR','Force Fill Internal Assessor','ACTIVITIES'
insert into sysform(FName, Description, FCode) Select 'INFORCEBATCH','Allow Inforce Batch','ACTIVITIES'



--10 September 2015 : Penambahan Proses AutoEmail_Notification untuk melakukan notifikasi Task2 melalui Email kepada User

insert into SysProcess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF)
Select 'AUTOEMAIL_NOTIFICATION','SC',0,'00:00','24:00',0,1,31,0,0
go



-- 6 October 2015 : Penamabah Privileges ALLOWCLDEDEXCOST untuk approval Claim dimana nilai deducible lebih besar dari Claim Loss + Cost
insert into Sysform(FName, Description, FCode, RequestF) Select 'ALLOWCLDEDEXCOST','Allow Claim Deductible Exceed Cost','ACTIVITIES',0
GO


Insert into MParam(Type, Remarks, MemorialF, Effective, Last_Opr, Last_Update) 
Select 'PD','Policy Deposit',0,getdate(),'CARE',getdate()
GO


--22 October 2015 : Penambahan Activities ALLOWCHANGEINFO - Untuk Memperbolehkan merubah deskripsi Object Info (waulupun kondisi Setting not editable)

insert into sysform(FName, Description, FCode) Select 'ALLOWCHANGEINFO','Allow Change Object Info','ACTIVITIES'
go


--17 November 2015 : Penambahan Activities ALLOWPRECEDEFAC - Untuk otorisasi apakah Opsi Precede Facultative Bisa di Pilih

insert into sysform(FName, Description, FCode) Select 'ALLOWPRECEDEFAC','Allow Precede Facultative Cession','ACTIVITIES'
go


--26 November 2015 : Penambahan Activites FORCEFILLWPC - Untuk Keharusan pengisian WPC

insert into sysform(FName, Description, FCode) Select 'FORCEFILLWPC','Force Fill WPC (UW)','ACTIVITIES'
go


--3 February 2016 : 

insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWPASSUSERSEGMENT', 'Allow ByPass User Segment Map', 'ACTIVITIES',0
go

--29 March 2016 : 
insert into Sysform(FName, Description, FCode) Select 'ALLOWOTHERBIZSRC','Allow Use Other Business Source','ACTIVITIES'
go

--14 June 2016
Insert into Sysform (FName, Description, FCode, RequestF)
Select 'ALLOWZEROESTIMATE', 'Allow Entry Zero Loss Estimate','ACTIVITIES',0
go


