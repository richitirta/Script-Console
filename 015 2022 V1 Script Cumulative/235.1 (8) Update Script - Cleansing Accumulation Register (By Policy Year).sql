Begin tran


truncate table accregdet
GO

CREATE TABLE [#ACCREGDET] (
	[REGNO] [int] NOT NULL IDENTITY(1,1),
	[RTYPE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[REGID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FLDID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[VALUEID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[AMOUNT] [float] NULL DEFAULT (0),
	[TSI] [float] NULL DEFAULT (0),
	[RYEAR] [int] NULL ,
) 
GO

-- Update PCTSHARE or PCTLOSS
Update RArrHeader set PCTSHARE=100 Where PCTSHARE IS NULL OR PCTSHARE=0
Update RArrHeader set PCTLOSS=100 Where PCTLOSS IS NULL OR PCTLOSS=0

-- Reset Accumulation Status
Update R Set R.Status='R' from RArrHeader R

Update R Set R.Status='A' from Acceptance A1, RArrHeader R 
Where R.ANO=A1.ANO 
and A1.NoRiskAccumulationF=0
and A1.AType in ('N','E')
and A1.pStatus='C'
and A1.AStatus<>'C'
and not exists (Select pANO from Acceptance A2 Where A2.PANO=A1.ANO and pStatus='C' and (AType in ('E') or (AType in ('C') and AStatus not in ('W','T'))))
and not exists (Select ANO from Acceptance A2 Where A2.ANO=A1.RANO and A2.AStatus<>'C')

--Update Acceptance Set RegID=TOC.RegID from Acceptance, Cover, TOC Where TOC.TOC=Acceptance.TOC and Cover.CNO=Acceptance.CNO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc1 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID1=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc2 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID2=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc3 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID3=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc4 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID4=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc5 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID5=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO
--Update Acceptance Set ValueDesc=cast(AInfo.ValueDesc6 as varchar(255))  from Acceptance, AInfo Where AInfo.FLDID6=Acceptance.FLDID and Acceptance.ANO=AINFO.ANO

Update RArrheader Set CRegno=-1,DRegNo=-1,XPRegNo=-1, QREGNO=-1, SP1REGNO=-1, SP2REGNO=-1, SP3REGNO=-1, AREGNO=-1
Update RArrheader Set QSRAmount=QAmount Where QSRet=100 and QSRAmount=0
Update RArrheader Set QShare=0, QAmount=0, QSRAmount=QShare*TAmount/100 Where QSRet=100 and QShare<>0
Update RArrheader Set CAmount=CShare*TAmount/100, DAmount=DShare*TAmount/100, XPAmount=XPShare*TAmount/100, QAmount=QShare*TAmount/100, SP1Amount=SP1Share*TAmount/100, SP2Amount=SP2Share*TAmount/100, SP3Amount=SP3Share*TAmount/100, AAmount=AShare*TAmount/100, FAmount=FShare*TAmount/100
Update RArrheader Set QSRAmount = QAmount*100/(100-QSRet)*QSRet/100 Where QSRet<>100
Update RArrheader Set RAmount=TAmount-MAmount-DAmount-CAmount-XPAmount-QAmount-QSRAmount-SP1Amount-SP2Amount-SP3AMOUNT-AAMOUNT-AFRAMOUNT-FAMOUNT-SAMOUNT
Update RArrheader Set Retention=Ramount/TAmount*100 Where TAmount<>0
Update RArrheader Set PCTShare=100 Where Status='A' and PCTShare=0

-- Compulsory Portion (100% for Direct Business)

insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'C' as RTYPE, Year(R.RDate) as RYear,
sum(R.TAMOUNT/(R.PctShare/100*R.PctLoss/100)) as TSI,
sum(R.CAmount/(R.PctShare/100*R.PctLoss/100* (100 - R.MShare) / 100)) as Amount
from acceptance A inner join cover C on (C.CNO=A.CNO and C.ProformaF=0) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.CID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.CREGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='C' AND D.RYEAR=YEAR(R.RDATE)


-- Decree Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'D' as RTYPE, Year(R.RDate) as RYear,
sum(R.TAMOUNT/(R.PctShare/100*R.PctLoss/100)) as TSI,
sum(R.DAmount/(R.PctShare/100*R.PctLoss/100* (100 - R.MShare) / 100)) as Amount
from acceptance A inner join cover C on (C.CNO=A.CNO and C.ProformaF=0) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.DID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)


Update R Set R.DREGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='D' AND D.RYEAR=YEAR(R.RDATE)

-- PRGBI (XP) Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'XP' as RTYPE, Year(R.RDate) as RYear,
sum(R.TAMOUNT/(R.PctShare/100*R.PctLoss/100)) as TSI,
sum(R.XPAmount/(R.PctShare/100*R.PctLoss/100* (100 - R.MShare) / 100)) as Amount
from acceptance A inner join cover C on (C.CNO=A.CNO and C.ProformaF=0) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.XPID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.XPREGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='XP' AND D.RYEAR=YEAR(R.RDATE)


-- Quota Share Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'Q' as RTYPE, Year(R.RDate) as RYear, SUM(R.TAMOUNT*(100-R.MShare)/100) AS TSI, SUM(R.QAMOUNT+R.QSRAMOUNT) AS AMOUNT
from acceptance A inner join cover C on (C.CNO=A.CNO) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.QID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.QREGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='Q' AND D.RYEAR=YEAR(R.RDATE)


-- Surplus #1 Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'S1' as RTYPE, Year(R.RDate) as RYear, SUM(R.TAMOUNT*(100-R.MShare)/100) AS TSI, SUM(R.SP1AMOUNT) AS AMOUNT
from acceptance A inner join cover C on (C.CNO=A.CNO) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.SP1ID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.SP1REGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='S1' AND D.RYEAR=YEAR(R.RDATE)


-- Surplus #2 Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'S2' as RTYPE, Year(R.RDate) as RYear, SUM(R.TAMOUNT*(100-R.MShare)/100) AS TSI, SUM(R.SP2AMOUNT) AS AMOUNT
from acceptance A inner join cover C on (C.CNO=A.CNO) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.SP2ID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.SP2REGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='S2' AND D.RYEAR=YEAR(R.RDATE)


-- Surplus #3 Portion
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'S3' as RTYPE, Year(R.RDate) as RYear, SUM(R.TAMOUNT*(100-R.MShare)/100) AS TSI, SUM(R.SP3AMOUNT) AS AMOUNT
from acceptance A inner join cover C on (C.CNO=A.CNO) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.SP3ID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.SP3REGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='S3' AND D.RYEAR=YEAR(R.RDATE)


-- Auto Fac
insert into #accregdet(REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) 
Select A.REGID,A.FLDID, A.VALUEID, 'A' as RTYPE, Year(R.RDate) as RYear, SUM(R.TAMOUNT*(100-R.MShare)/100) AS TSI, SUM(R.AAMOUNT) AS AMOUNT
from acceptance A inner join cover C on (C.CNO=A.CNO) Left Join ISource I On (I.CNO=C.CNO) inner join RArrHeader R ON (R.ANO=A.ANO)
Where A.NoRiskAccumulationF=0 and R.Status='A' and A.FLDID<>'' and A.VALUEID<>'' and R.AID<>''
Group By A.REGID, A.FLDID, A.VALUEID, YEAR(R.RDATE)

Update R Set R.AREGNO=D.REGNO 
from RARRHEADER R, ACCEPTANCE A, #ACCREGDET D 
WHERE A.ANO=R.ANO AND R.STATUS='A' AND D.REGID=A.REGID AND D.FLDID=A.FLDID AND D.VALUEID=A.VALUEID AND D.RTYPE='A' AND D.RYEAR=YEAR(R.RDATE)

insert into AccRegDet(REGNO, REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT) SELECT REGNO, REGID,FLDID,VALUEID,RTYPE, RYEAR,TSI,AMOUNT FROM #ACCREGDET

Delete from SysSeqNo Where ObjName='AccRegDet'
Insert into SysSeqNo(ObjName,SeqNo) Select 'AccRegDet',Max(RegNo) from AccRegDet

Drop Table #AccRegDet

GO

Select RegNo, RType, RegID, FLDID, ValueID, RYear, Count(*) as NRisk into #AccRegDet

from(
Select R.CRegNo as RegNo, 'C' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.CRegNo>0

union all

Select R.QRegNo as RegNo, 'Q' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.QRegNo>0

union all

Select R.SP1RegNo as RegNo, 'S1' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.SP1RegNo>0

union all

Select R.SP2RegNo as RegNo, 'S2' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.SP2RegNo>0

union all


Select R.SP3RegNo as RegNo, 'S3' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.SP3RegNo>0

union all

Select R.XPRegNo as RegNo, 'XP' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.XPRegNo>0

union all

Select R.DRegNo as RegNo, 'D' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.DRegNo>0

union all

Select R.ARegNo as RegNo, 'A' as RType, A.RegID, A.FLDID, A.ValueID, Year(R.RDate) as RYear 
from RArrHeader R, Acceptance A 
Where A.ANO=R.ANO and R.Status='A' and R.ARegNo>0
) AccRegDet

Group By RegNo, RType, RegID, FLDID, ValueID, RYear

GO

Update A1 set NRisk=A2.NRisk, ReAllocF = Case When A2.NRisk>1 Then 1 else 0 end 
from AccRegDet A1, #AccRegDet A2
Where A1.RegNo=A2.RegNo and A1.RType=A2.RType and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.ValueID=A2.ValueID and A1.RYear=A2.RYear


drop table #AccRegDet

Commit tran

 insert into PatchVersioning
select '235.1 (8) Update Script - Cleansing Accumulation Register (By Policy Year)',GETDATE()
go
