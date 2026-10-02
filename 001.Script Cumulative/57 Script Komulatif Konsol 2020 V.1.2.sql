--Update Script 2020 V1.2
--18 Agst 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RID' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
	RID varchar(20) Null
	DECLARE @v sql_variant 
SET @v = N'Reinsurance ID (or FID for Facultative)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'RID'
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FileType' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	FileType varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'File Type (For Type of File)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'FileType'
end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImageID' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	ImageID varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'Upload Document (see SysImage)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ImageID'
	end
	go

	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionBy' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	ActionBy varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'Action Taken By'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionBy'
	end
	go
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionDate' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
ActionDate varchar(10) Null
DECLARE @v sql_variant 
SET @v = N'Date Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionDate'
	end
	go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionTime' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
ActionTime varchar(10) Null
DECLARE @v sql_variant 
SET @v = N'Time Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionTime'
	end
	go
	
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedTime' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedTime varchar(8) NULL
DECLARE @v sql_variant 
SET @v = N'Time Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'AcceptedTime'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedBy' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedBy varchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedDate' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedDate smalldatetime NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Opr varchar(50) NULL
end
go	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Update smalldatetime NULL
end
go	 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Time varchar(8) NULL
end
go	 




GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLNotify' AND CONSTRAINT_NAME='I_CLNotify')
Begin
Alter Table CLNotify drop constraint I_CLNotify
end
GO

Alter Table CLNotify alter column Currency_OC varchar(10) Null
GO
Select CNO, Type, '' as RID, ID, Document, Max(Currency_OC) as Currency_OC, Max(cast(Remarks as varchar(1024))) as Remarks, Max(UserID) as UserID, Max(Date) as Date, max(Time) as Time, Max(ImageID) as ImageID, Max(FileType) as FileType into #CLNotify
from CLNotify
group by CNO, Type, ID, Document
GO
truncate table CLNotify
GO
insert into CLNotify(CNO, Type, RID, ID, Document, Currency_OC, Remarks, UserID, Date, Time, ImageID, FileType) Select * from #CLNotify 
GO
drop table #CLNotify 
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID(N'CLNotify'))
Begin
Create Unique Index I_CLNotify on CLNotify(CNO, Type, RID, ID, Document)
end
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLView20') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure CLView20
END
GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, 
@CNO as CNO, C1.*, C1.Estimate*C1.Share/100 as PEStimate, C1.Indemnity*C1.Share/100 as PIndemnity, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL7ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	(R1.Share-R1.JPShare) as Share
	from Acceptance A, Claim C, RArrHeader R, RArrDet R1, FPart R2, CArrheader     
	Where R1.FullCoverF=1 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=A.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	and C.CNO=@CNO

	union all

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	(R1.Share-R1.JPShare) as Share
	from Acceptance A, Claim C, COL, RArrHeader R, RArrDet R1, FPart R2, CArrHeader, FPartDet,
	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	GROUP BY C.CNO
	) CCALC
	Where R1.FullCoverF=0 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=C.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND COL.COL=C.COL AND CCALC.CNO=C.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	AND FPartDet.ANO=R1.ANO AND FPartDet.FID=R1.FID AND FPartDet.ID=R2.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)    
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	And C.CNO=@CNO
) C1
Inner Join Profile on (Profile.ID=C1.ID)
Inner join Claim on (Claim.CNO=@CNO)
Inner Join (
	Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
	from Docstat D, SysClass S 
	Where D.Purpose='RI' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
	) S on (
		exists (Select Top 1 Document from CLNotify C2 Where C2.CNO=@CNO and C2.Type=C1.Type and C2.RID=C1.RID and C2.ID=C1.ID and S.Document=C2.Document)
		or
		(charindex(Claim.CType, S.ClaimCType)>0 and charindex(Claim.CStatus, S.ClaimCStatus)>0)
	)
Left Join CLNotify C2 on (C2.CNO=@CNO and C2.Type=C1.Type and C2.RID=C1.RID and C2.ID=C1.ID and S.Document=C2.Document)
Where 
(C1.Type in ('X1','X2','X3','X4','X5','X6','X7','FO') or (C1.CLAIMCOOP>0 and C1.Estimate>=C1.ClaimCoop) or (C1.CashCallLimit>0 and C1.Indemnity>=C1.CashCallLimit) or (C1.PLALimit>0 and C1.Estimate>=C1.PLALimit))
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))

GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWPASSCLAIMRINOTIFICATION')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWPASSCLAIMRINOTIFICATION','ALLOW PASS CLAIM RI NOTIFICATION (CL)','ACTIVITIES',0
end
go
--30 Sept 2020

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataType' AND Object_ID = Object_ID(N'CollType'))
begin
ALTER TABLE CollType ADD
	DataType varchar(30) NULL

DECLARE @v sql_variant 
SET @v = N'Data Type (''OUTSTANDING DUE'', ''AMOUNT DUE IN PERIOD'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CollType', N'COLUMN', N'DataType'
end
GO


GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataType' AND Object_ID = Object_ID(N'CollectionH'))
begin
ALTER TABLE CollectionH ADD
	DataType varchar(30) NULL

DECLARE @v sql_variant 
SET @v = N'Data Type (''OUTSTANDING DUE'', ''AMOUNT DUE IN PERIOD'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CollectionH', N'COLUMN', N'DataType'
end
GO


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoGenerateBilling_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure AutoGenerateBilling_Process
END
GO
CREATE Procedure AutoGenerateBilling_Process(@P_PDate as smalldatetime)                                            
as                                  

Select C1.CollType, C1.AutoNum, C1.Segment, C1.CGroup, C1.TOC, C1.AutoCollBy, C2.Reminder, C2.Description, C1.DataType, C2.Day_1, C2.Day_2, C2.RuleID, C2.Class, C2.Erule, A.RepName, A.ExeName, A.NeedEmailF, A.NeedPrintF
from CollType C1, CollType_RRule C2, APDRuleD A
Where C1.AllowedF=1 and C2.CollType=C1.CollType and C1.AutoCollby<>'' and A.RuleID=C2.RuleID and A.Class=C2.Class
and C2.DDay=day(@P_PDate)
Order By C1.CollType, C2.Reminder

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTPERIODDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTPERIODDUE
END
GO
CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Nominal_CC, V.Diff_CC, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,        
(
Case When V.Installment=0 and V.DueDate Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case  
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.DueDate_24    
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.DueDate_23    
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.DueDate_22    
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.DueDate_21       
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.DueDate_20    
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.DueDate_19    
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.DueDate_18    
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.DueDate_17    
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.DueDate_16    
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.DueDate_15
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.DueDate_14    
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.DueDate_13    
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.DueDate_12    
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.DueDate_11        
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.DueDate_10    
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.DueDate_9    
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.DueDate_8    
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.DueDate_7    
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.DueDate_6    
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.DueDate_5    
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.DueDate_4    
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.DueDate_3    
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.DueDate_2    
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.DueDate_1    
Else V.DueDate End as DueDate,        

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then '1 ' else '' end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then '2 ' else '' end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then '3 ' else '' end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then '4 ' else '' end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then '5 ' else '' end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then '6 ' else '' end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then '7 ' else '' end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then '8 ' else '' end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then '9 ' else '' end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then '10 ' else '' end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then '11 ' else '' end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then '12 ' else '' end+      
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then '13 ' else '' end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then '14 ' else '' end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then '15 ' else '' end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then '16 ' else '' end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then '17 ' else '' end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then '18 ' else '' end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then '19 ' else '' end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then '20 ' else '' end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then '21 ' else '' end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then '22 ' else '' end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then '23 ' else '' end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then '24 '      
Else '' end+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment      
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)                  

)      


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_AUTO_COLLECT_PERIOD_DUE_NET_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_AUTO_COLLECT_PERIOD_DUE_NET_ALL
END
GO
Create function CL_AUTO_COLLECT_PERIOD_DUE_NET_ALL(@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Admlink.A_MO as MO, Admlink.Source, Admlink.A_ID as Holder, '' as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal, Voucher.AmountDue as Amount, Voucher.Payment_CC as Payment, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and 
(
(Admlink.Type in ('BB','BO','BA','BC') and Admlink.ID=Admlink.Source)
or
(Admlink.Type in ('DI','IC','IR'))
)
and Admlink.ISType in ('I','L','C')
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Subject='Premium'  
)  


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_AUTO_COLLECT_ALL_NET') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function CL_AUTO_COLLECT_ALL_NET 
END
GO
CREATE function CL_AUTO_COLLECT_ALL_NET (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Admlink.A_MO as MO, Admlink.Source, Admlink.A_ID as Holder, '' as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal, Voucher.AmountDue as Amount, Voucher.Payment_CC as Payment, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and 
(
(Admlink.Type in ('BB','BO','BA','BC') and Admlink.ID=Admlink.Source)
or
(Admlink.Type in ('DI','IC','IR'))
)
and Admlink.ISType in ('I','L','C')
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Subject='Premium'  

) 

go

--2 Oct 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M1'))
begin
ALTER TABLE RATECON_M1 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M1', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M2'))
begin
ALTER TABLE RATECON_M2 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M2', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M3'))
begin
ALTER TABLE RATECON_M3 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M3', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M4'))
begin
ALTER TABLE RATECON_M4 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M4', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M5'))
begin
ALTER TABLE RATECON_M5 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M5', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M6'))
begin
ALTER TABLE RATECON_M6 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M6', N'COLUMN', N'SRate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SRate' AND Object_ID = Object_ID(N'RATECON_M7'))
begin
ALTER TABLE RATECON_M7 ADD
	SRate float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Surchage Rate (see RCover SRate), Rate = BRate + SRate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECON_M7', N'COLUMN', N'SRate'
end
GO




GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RateLoading') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_RateLoading
END
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512), CID varchar(512), AggregateTSI Float, SRate Float)   
AS     
BEGIN       
Declare @SPeriod Int
Declare @SDate smalldatetime
Declare @EDate smalldatetime
Declare @TOPRO varchar(10)
Declare @PHolder varchar(10)
Declare @CheckRateConSIBy int
Declare @OANO Int
Declare @REGID varchar(10)
Declare @FLDID varchar(255)
Declare @VALUEID varchar(255)
Declare @AgeMethod Int


Declare @RateTab Table (
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)
Declare @SRate as Float

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''
Select @SRate=0


Select @AgeMethod=TOC.AgeMethod, @OANO=A.OANO, @RegID=A.RegID, @FLDID=A.FLDID, @ValueID=A.ValueID, @PHolder=C.PHolder, @SDate=@P_PDate, @EDate=A.EDate, @TOPRO=A.TOPRO, @CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0), @SPeriod=RateTab.SPeriod
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO) Inner Join TOC on (TOC.TOC=A.TOC) Left Join TOPRO T on (T.TOPRO=A.TOPRO), RateTab
Where A.ANO=@P_ANO and RateTab.Code=@P_Code

Select @P_TSI=@P_TSI+case 
	When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@TOPRO,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@PHolder,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@RegID, @FLDID, @VALUEID,@OANO)
	else 0
	end

insert into @RateTab
SELECT Top 1 
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H1.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc1) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID2 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H2.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc2) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID3 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H3.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc3) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID4 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H4.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc4) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID5 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H5.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc5) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID6 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H6.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc6) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID7 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H7.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc7) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID8 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H8.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc8) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID9 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H9.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc9) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID10 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H10.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc10) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID11 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H11.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc11) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID12 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H12.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc12) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID13 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H13.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc13) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID14 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H14.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc14) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID15 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H15.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc15) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID15
From AINFO
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (H1.FLDTAB=1 and G1.FLDID=AInfo.FLDID1 and G1.ValueID=AInfo.ValueID1)
 Left Join GenDTab G2 on (H2.FLDTAB=1 and G2.FLDID=AInfo.FLDID2 and G2.ValueID=AInfo.ValueID2)
 Left Join GenDTab G3 on (H3.FLDTAB=1 and G3.FLDID=AInfo.FLDID3 and G3.ValueID=AInfo.ValueID3)
 Left Join GenDTab G4 on (H4.FLDTAB=1 and G4.FLDID=AInfo.FLDID4 and G4.ValueID=AInfo.ValueID4)
 Left Join GenDTab G5 on (H5.FLDTAB=1 and G5.FLDID=AInfo.FLDID5 and G5.ValueID=AInfo.ValueID5)
 Left Join GenDTab G6 on (H6.FLDTAB=1 and G6.FLDID=AInfo.FLDID6 and G6.ValueID=AInfo.ValueID6)
 Left Join GenDTab G7 on (H7.FLDTAB=1 and G7.FLDID=AInfo.FLDID7 and G7.ValueID=AInfo.ValueID7)
 Left Join GenDTab G8 on (H8.FLDTAB=1 and G8.FLDID=AInfo.FLDID8 and G8.ValueID=AInfo.ValueID8)
 Left Join GenDTab G9 on (H9.FLDTAB=1 and G9.FLDID=AInfo.FLDID9 and G9.ValueID=AInfo.ValueID9)
 Left Join GenDTab G10 on (H10.FLDTAB=1 and G10.FLDID=AInfo.FLDID10 and G10.ValueID=AInfo.ValueID10)
 Left Join GenDTab G11 on (H11.FLDTAB=1 and G11.FLDID=AInfo.FLDID11 and G11.ValueID=AInfo.ValueID11)
 Left Join GenDTab G12 on (H12.FLDTAB=1 and G12.FLDID=AInfo.FLDID12 and G12.ValueID=AInfo.ValueID12)
 Left Join GenDTab G13 on (H13.FLDTAB=1 and G13.FLDID=AInfo.FLDID13 and G13.ValueID=AInfo.ValueID13)
 Left Join GenDTab G14 on (H14.FLDTAB=1 and G14.FLDID=AInfo.FLDID14 and G14.ValueID=AInfo.ValueID14)
 Left Join GenDTab G15 on (H15.FLDTAB=1 and G15.FLDID=AInfo.FLDID15 and G15.ValueID=AInfo.ValueID15)
WHERE AINFO.ANO=@P_ANO                       

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)
Declare @Temp_SRate as Float

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)             
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)   
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,      
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)             
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                        
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)      
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)              
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (datediff(month, @SDate, @EDate)>=RateCon.MinPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MinPeriod-1 and day(@SDate)<day(@EDate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, @SDate, @EDate)<RateCon.MaxPeriod)     
	 or (datediff(month, @SDate, @EDate)=RateCon.MaxPeriod and day(@SDate)>=day(@EDate))     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)           
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,    
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

insert into @RateCon Select @Loading, @HoldF,@HoldMessage,@CID, @P_TSI, @SRate
Return
END  


GO



--12 Oct 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HoldMessage' AND Object_ID = Object_ID(N'RISKASS'))
begin
ALTER TABLE RISKASS ADD
	HoldMessage varchar(512) NULL

DECLARE @v sql_variant 
SET @v = N'Message for Hold Flag'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RISKASS', N'COLUMN', N'HoldMessage'
end
GO
GO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRiskAssLimit') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QRiskAssLimit 
END
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.HoldMessage, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (((@RType='' and Reinsurance.RType In ('Q')) or Reinsurance.RType=@RType) and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))     
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        





go


--13 Oct 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExtRSDate' AND Object_ID = Object_ID(N'ACCEPTANCE'))
begin
ALTER TABLE ACCEPTANCE ADD
	ExtRSDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Exten Risk Period Start'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ExtRSDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExtREDate' AND Object_ID = Object_ID(N'ACCEPTANCE'))
begin
ALTER TABLE ACCEPTANCE ADD

	ExtREDate smalldatetime NULL
	
DECLARE @v sql_variant 
SET @v = N'Extent Risk Period end'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ExtREDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExtRPeriod' AND Object_ID = Object_ID(N'ACCEPTANCE'))
begin
ALTER TABLE ACCEPTANCE ADD
		ExtRPeriod int NULL
DECLARE @v sql_variant 
SET @v = N'ExtRPeriod in Month'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ExtRPeriod'
end
GO




GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_DED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_DED 
END
GO
Create Function FL_CL_DED (@P_CNO AS INTEGER) 
RETURNS TABLE 
AS RETURN  ( 
--QCLACC02 
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, Claim.Payment as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER
WHERE CLAIM.CNO=@P_CNO 
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO 
and RCalc.ANO=ACCDED.ANO and ACCDED.TOR=RCalc.TOR
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate  
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    
) 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEDUCTIBLE_CALC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QDEDUCTIBLE_CALC 
END
GO
CREATE PROCEDURE QDEDUCTIBLE_CALC (@P_CNO AS integer, @P_DCODE AS Varchar(10))   
AS   
SELECT CNO, DEDCCY, DCODE, CURRENCY, MAX(PAYMENT) AS PAYMENT, MAX(REMARKS) AS REMARKS, MAX(FIXEDMIN) AS FIXEDMIN, MAX(FIXEDMAX) AS FIXEDMAX, SUM(DEDTSI) AS DEDTSI, SUM(DEDEST) AS DEDEST, SUM(DEDCL) AS DEDCL, SUM(LOSSESTIMATE) as LOSSESTIMATE, SUM(LOSSCLAIM) AS LOSSCLAIM   
From   
(   
SELECT CLAIM.CNO,   
CLLOSS.CURRENCY AS DEDCCY,   
ACCDED.DCODE,   
ACCDED.CURRENCY,   
CLLOSS.INO,   
MAX(CASE WHEN ICOVER.CATEGORY='M' THEN CLAIM.PAYMENT ELSE '' END) as PAYMENT,   
MAX(ACCDED.REMARKS) AS REMARKS,   
MAX(ACCDED.FIXEDMIN) AS FIXEDMIN,   
MAX(ACCDED.FIXEDMAX) AS FIXEDMAX,   
MAX(Case When ACCDED.STRTSI='TSI' THEN PCALC.TSI ELSE CLLOSS.DECLARED END*ACCDED.PCTTSI*.01*CLLOSS.RATE*(1-RCOVER.COSHARE/100)) AS DEDTSI,   
SUM(CLLOSS.ESTIMATE*ACCDED.PCTCL*.01*(1-RCOVER.COSHARE/100)) AS DEDEST,   
SUM(CLLOSS.Amount * ACCDED.PCTCL * 0.01 * (1 - RCOVER.COSHARE / 100)) As DEDCL,   
SUM(CLLOSS.ESTIMATE) AS LOSSESTIMATE,   
SUM(CLLOSS.Amount) As LOSSCLAIM   
From CLAIM, ACCEPTANCE, ACCDED, CLLOSS, RCOVER, Col, DEDTAB, ICALC, PCALC, ICOVER
Where   
CLAIM.CNO=@P_CNO   
AND ACCEPTANCE.ANO=CLAIM.ANO   
AND ACCDED.ANO=CLAIM.ANO   
AND ACCDED.DCODE=@P_DCODE   
AND DEDTAB.DCODE=@P_DCODE AND (DEDTAB.CTLF=0 or DEDTAB.CTLF=CLLOSS.CTLF)
AND RCOVER.ANO=CLAIM.ANO   
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND CLLOSS.CNO=CLAIM.CNO   
AND COL.COL=CLAIM.COL   
AND COL.TOR=ACCDED.TOR  
AND ICALC.ANO=RCOVER.ANO
AND ICALC.CODE=RCOVER.CODE
AND ICALC.SDATE=RCOVER.SDATE
AND ICALC.INO=CLLOSS.INO
AND ICALC.Currency=CLLOSS.Currency_OC
AND ICALC.TOR=COL.TOR   
AND PCALC.ANO=ICALC.ANO
AND PCALC.CURRENCY=ICALC.CURRENCY
AND ICOVER.INO=CLLOSS.INO
AND (ACCDED.PCTTSI<>0 or ACCDED.PCTCL<>0 or (ACCDED.CURRENCY<>'' AND (ACCDED.FIXEDMIN<>0 or ACCDED.FIXEDMAX<>0)))   
GROUP BY CLAIM.CNO, CLLOSS.CURRENCY, ACCDED.DCODE, ACCDED.CURRENCY, CLLOSS.INO   
) DEDUCTIBLE   
GROUP BY CNO, DEDCCY, DCODE,CURRENCY   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_GetPolicyNOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_GetPolicyNOC 
END
GO
Create Function FL_GetPolicyNOC (@P_COL as varchar(10), @P_INO AS INTEGER)              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), Currency varchar(5), Amount Float)      
AS      
BEGIN          

Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
      
Select 
@P_LossDate=Acceptance.SDate, 
@P_LossTime=Acceptance.STime
from Acceptance, ICover Where ICover.INO=@P_INO and Acceptance.ANO=ICover.ANO
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO 
AND ACCEPTANCE.ANO=ICOVER.ANO    
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
END AS AMOUNT
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI 
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      




GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLSalvageTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLSalvageTo 
END
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    

SELECT cno, id, currency, CSType, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLSAL.CNO=@P_CNO AND CLSAL.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
) CLSAL
GROUP BY cno, id, currency, CSType 


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_4') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC_4
END
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 100 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC
From ACCEPTANCE, COVER   
WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO   
AND (
(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
 )             
AND 
(
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)        
Order By ACCEPTANCE.ANO Desc   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_TOI') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_TOI
END
GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI                
)   

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMFACOUT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLAIMFACOUT
END
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.ETAmount-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.ETAmount
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then 
	Case When CArrHeader.TAmount>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.TAmount-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.TAmount
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,

(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,


Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

(
SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
FROM LCALC L, CCALC C 
WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
GROUP BY L.CNO, L.TOR
) LCALC,
(
SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C
WHERE C.CNO=@P_CNO
GROUP BY C.CNO
) CCALC
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
AND RArrDet.Status='A'     

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QInConsistent_LossItem') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QInConsistent_LossItem
END
GO
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
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate))) 
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY-CLLOSS.DECLARED)<=1

UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END-CLLOSS.DECLARED)<=1
)  
          
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCALC01a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CCALC01a
END
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
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLLOSS.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.PAYMENT, CLLOSS.NOC, CLLOSS.Currency, CLLOSS.RefNo  
    
Union All            
                      
SELECT CLDED.CURRENCY, Max(RCOVER.CODE) as Code, max(RCALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, Max(CLDED.ESTAMOUNT) AS EDEDUCTIBLE, Max(CLDED.AMOUNT) AS DEDUCTIBLE, 0 as ESALVAGE, 0 AS SALVAGE            
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
    
                      
Union All            
                      
SELECT CLSAL.CURRENCY, Max(RCOVER.CODE) as Code, Max(ICALC.TOR) as TOR, 0 AS LOSS, 0 AS INDEMNITY, 0 AS EDEDUCTIBLE, 0 AS DEDUCTIBLE, MAX(CLSAL.EAMOUNT) AS ESALVAGE, Max(CLSAL.AMOUNT) AS SALVAGE
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLAIM.CNO=@P_CNO AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
)            

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLItemLossTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLItemLossTo 
END
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, CODEEXT, MAX(RCODE) AS RCODE, MAX(TOR) AS TOR, SUM(CLAIM) AS CLAIM, SUM(TAX) AS TAX, SUM(DEDUCTIBLE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo, MAX(NOCTAB.CODEEXT) AS CODEEXT, Max(RCOVER.CODE) AS RCODE, MAX(ICALC.TOR) AS TOR,
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
	From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, COVER, COL, NOCTAB    
	WHERE CLLOSS.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLLOSS.CNO 
	AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
	AND ICALC.INO=CLLOSS.INO    
	AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
	AND NOCTAB.NOC=CLLOSS.NOC
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO, CODEEXT

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CLACC_4') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FL_CLACC_4 
END
GO
CREATE FUNCTION FL_CLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS SMALLDATETIME) 
RETURNS TABLE 
AS RETURN 
( 
SELECT top 100 Acceptance.ANO, Acceptance.NCDate, Acceptance.AName, Acceptance.AType, Acceptance.AStatus, Acceptance.PDate as 'Effective Date', Acceptance.PPDate as 'Expiry Date' 
From ACCEPTANCE, COVER   
WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO   
AND (
(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE)) AND ACCEPTANCE.ExclusiveF=0)
 )             
AND 
(
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))=@P_DATE)) AND ACCEPTANCE.ExclusiveF=0)
)        
Order By ACCEPTANCE.ANO Desc   
) 
 
GO 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLView20') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure CLView20
END
GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, @CNO as CNO, C1.*, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL7ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	R2.Share
	from Acceptance A, Claim C, RArrHeader R, RArrDet R1, FPart R2, CArrheader     
	Where R1.FullCoverF=1 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=A.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	and C.CNO=@CNO

	union all

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	R2.Share
	from Acceptance A, Claim C, COL, RArrHeader R, RArrDet R1, FPart R2, CArrHeader, FPartDet,
	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	GROUP BY C.CNO
	) CCALC
	Where R1.FullCoverF=0 and A.ANO=C.ANO and R1.ANO=C.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND COL.COL=C.COL AND CCALC.CNO=C.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE))=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	AND FPartDet.ANO=R1.ANO AND FPartDet.FID=R1.FID AND FPartDet.ID=R2.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)    
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	And C.CNO=@CNO
) C1
Inner Join Profile on (Profile.ID=C1.ID)
Inner join Claim on (Claim.CNO=@CNO)
Inner Join (
	Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
	from Docstat D, SysClass S 
	Where D.Purpose='RI' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
	) S on (
		exists (Select Top 1 Document from CLNotify C2 Where C2.CNO=@CNO and C2.Type=C1.Type and C2.ID=C1.ID and S.Document=C2.Document)
		or
		(charindex(Claim.CType, S.ClaimCType)>0 and charindex(Claim.CStatus, S.ClaimCStatus)>0)
	)
Left Join CLNotify C2 on (C2.CNO=@CNO and C2.Type=C1.Type and C2.ID=C1.ID and S.Document=C2.Document)
Where 
(C1.Type in ('X1','X2','X3','X4','X5','X6','X7','FO') or (C1.CLAIMCOOP>0 and C1.Estimate>=C1.ClaimCoop) or (C1.CashCallLimit>0 and C1.Indemnity>=C1.CashCallLimit) or (C1.PLALimit>0 and C1.Estimate>=C1.PLALimit))
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCHECKDECLAREDVALUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCHECKDECLAREDVALUE 
END
GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select *
from
(
Select 
SUM(CLLOSS.Estimate/CLLOSS.Rate) as Estimate, 
SUM(CLLOSS.Amount/CLLOSS.Rate) as Amount, 
MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED,
MAX(ICOVER.AMOUNT) as LOL
from CLLOSS 
INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
LEFT JOIN ICOVERNOC ON ((ICoverNOC.PCT<>0 or (ICoverNOC.Amount<>0 and ICoverNOC.MaxQty=0)) And ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate
 or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 
Where CLLOSS.Declared>1 and CLLoss.CNO=@PCNO and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
) C
WHere Estimate>Declared or Amount>declared or Estimate>LOL or Amount>LOL


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_NOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_NOC 
END
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
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
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
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN

DROP PROCEDURE QCLACC01 
END
GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))
WHERE CLAIM.CNO=@PCNO AND ACCEPTANCE.ANO=CLAIM.ANO 
AND ICOVER.ANO=CLAIM.ANO AND (@PINO=0 or ICOVER.INO=@PINO) 
AND TOI.TOI=ICOVER.TOI
AND COL.COL=CLAIM.COL
AND RCOVER.ANO=ACCEPTANCE.ANO        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND ICALC.ANO=CLAIM.ANO AND ICalc.Currency=ICOVER.Currency AND ICalc.Code=RCover.Code AND ICALC.TOR=COL.TOR and ICalc.INO=ICover.INO and ICalc.SDate=RCover.SDate

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC02 
END
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)   
AS   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, Claim.Payment as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER
WHERE CLAIM.CNO=@P_CNO 
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO 
and RCalc.ANO=ACCDED.ANO and ACCDED.TOR=RCalc.TOR
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate  
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFDEDUCTIBLE_CALC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QFDEDUCTIBLE_CALC 
END
GO
CREATE PROCEDURE QFDEDUCTIBLE_CALC (@P_CNO AS integer, @P_FID AS VARCHAR(20), @P_DCODE AS Varchar(10))   
AS   
SELECT CNO, DEDCCY, DCODE,CURRENCY, MAX(REMARKS) AS REMARKS, MAX(FIXEDMIN) AS FIXEDMIN, MAX(FIXEDMAX) AS FIXEDMAX, SUM(DEDTSI) AS DEDTSI, SUM(DEDCL) AS DEDCL, SUM(LOSSESTIMATE) as LOSSESTIMATE, SUM(LOSSCLAIM) AS LOSSCLAIM   
From   
(   
SELECT CLAIM.CNO,   
CLLOSS.CURRENCY AS DEDCCY,   
FDEDUCTIBLE.DCODE,   
FDEDUCTIBLE.CURRENCY,   
CLLOSS.INO,   
MAX(FDEDUCTIBLE.REMARKS) AS REMARKS,   
MAX(FDEDUCTIBLE.FIXEDMIN) AS FIXEDMIN,   
MAX(FDEDUCTIBLE.FIXEDMAX) AS FIXEDMAX,   
MAX(Case When FDEDUCTIBLE.STRTSI='TSI' THEN PCALC.TSI ELSE CLLOSS.DECLARED END*FDEDUCTIBLE.PCTTSI*.01*CLLOSS.RATE) AS DEDTSI,   
SUM(CLLOSS.ESTIMATE*FDEDUCTIBLE.PCTCL*.01*(1-RCOVER.COSHARE/100)) AS DEDEST,   
SUM(CLLOSS.Amount * FDEDUCTIBLE.PCTCL * 0.01 * (1 - RCOVER.COSHARE / 100)) As DEDCL,   
SUM(CLLOSS.ESTIMATE) AS LOSSESTIMATE,   
SUM(CLLOSS.Amount) As LOSSCLAIM   
From CLAIM, ACCEPTANCE, FDEDUCTIBLE, CLLOSS, Col, RCOVER, RArrDet, ICALC, PCALC, DedTab  
Where   
CLAIM.CNO=@P_CNO   
AND ACCEPTANCE.ANO=CLAIM.ANO   
AND FDEDUCTIBLE.ANO=CLAIM.ANO   
AND FDEDUCTIBLE.DCODE=@P_DCODE   
AND FDEDUCTIBLE.FID=@P_FID   
AND DEDTAB.DCODE=@P_DCODE AND (DEDTAB.CTLF=0 or DEDTAB.CTLF=CLLOSS.CTLF)
AND RARRDET.ANO=FDEDUCTIBLE.ANO   
AND RARRDET.FID=@P_FID   
AND RCOVER.ANO=CLAIM.ANO   
AND (RCover.RetroActiveF=1 or (RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND CLLOSS.CNO=CLAIM.CNO   
AND COL.COL=CLAIM.COL   
AND COL.TOR=FDEDUCTIBLE.TOR  
AND ICALC.ANO=RCOVER.ANO
AND ICALC.CODE=RCOVER.CODE
AND ICALC.SDATE=RCOVER.SDATE
AND ICALC.INO=CLLOSS.INO
AND ICALC.Currency=CLLOSS.Currency_OC
AND ICALC.TOR=COL.TOR   
AND PCALC.ANO=ICALC.ANO
AND PCALC.CURRENCY=ICALC.CURRENCY
AND (FDEDUCTIBLE.PCTTSI<>0 or FDEDUCTIBLE.PCTCL<>0 or FDEDUCTIBLE.FIXEDMIN<>0 or FDEDUCTIBLE.FIXEDMAX<>0)   
GROUP BY CLAIM.CNO, CLLOSS.CURRENCY, FDEDUCTIBLE.DCODE, FDEDUCTIBLE.CURRENCY, CLLOSS.INO   
) DEDUCTIBLE   
GROUP BY CNO, DEDCCY, DCODE,CURRENCY   
   
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLDEDTO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLDEDTO 
END
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(C.Amount) AS amount
FROM
(
SELECT CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.CURRENCY, MAX(CLDED.REFNO) AS REFNO, Max(CLDED.AMOUNT) AS AMOUNT, Max(RCOVER.CODE) as RCode, MAX(RCALC.TOR) AS TOR
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLDED.CNO=@P_CNO AND CLDED.CURRENCY=@P_CUrrency AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
) C
GROUP BY C.CNO, C.ID, C.CURRENCY, C.RefNo

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLNOC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLNOC
END
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
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              

          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
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
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))          

      
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_FacCoinsuranceShare') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function get_FacCoinsuranceShare
END
GO
CREATE Function get_FacCoinsuranceShare(@P_CNO integer)          
RETURNS Float AS        
  
BEGIN       
Declare @Share as Float
Select @Share=sum(Share)
from
(
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end) as Share
	From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
	WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
	AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
	AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')          
                          
	Union All                    
                          
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit+RArrDet.Excess)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share
	From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=@P_CNO
	GROUP BY C.CNO
	) CCALC
	WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
	AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
	AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
	AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')
) R

Return @Share
End


go

--13 Oct 2020 (1)
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_PCalc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_PCalc
END
GO
Create FUNCTION FN_PCalc (@P_ANO as integer)            
RETURNS Table            
AS RETURN (            
SELECT  Acceptance.ANO,            
 Count(PCalc.Currency) AS NUMCCY,          
 MAX(PCALC.LMFACTOR) AS LMFACTOR,
 MAX(PCALC.RATE) AS RATE,          
 MAX(PCALC.CRATE) AS CRATE,         
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,            
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,            
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,            
 (Select sum(Rcalc.OGross/Rcalc.Prorata*Pcalc.Rate) from RCalc, PCalc Where RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency and Pcalc.ANO=Acceptance.ANO)*Max(Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OGross,            
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,            
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/            
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*            
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,            
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE, 
 MAX(RARRHEADER.MSHARE) as MSHARE
FROM  Acceptance with(NOLOCK)       
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')       
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)      
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)            
Where Acceptance.ANO=@P_ANO            
GROUP BY Acceptance.ANO            
)            

GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DecreasePremiumF' AND Object_ID = Object_ID(N'PAYOR'))
begin
ALTER TABLE PAYOR ADD
	DecreasePremiumF bit NULL

DECLARE @v sql_variant 
SET @v = N'Premium Calculation by Decreasing SI (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'DecreasePremiumF'
end
GO


GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DecreasePremiumF' AND Object_ID = Object_ID(N'APayor'))
begin
ALTER TABLE APayor ADD
	DecreasePremiumF bit NULL

DECLARE @v sql_variant 
SET @v = N'Premium Calculation by Decreasing SI (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APayor', N'COLUMN', N'DecreasePremiumF'
end
GO




--14 Oct 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_VAccount_info') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Get_VAccount_info
END
GO
CREATE Procedure Get_VAccount_info(@P_VID int, @P_AccountNo varchar(150), @P_ByCollectionF as Bit=0)
As
 Declare @Bank varchar(10)
 Declare @CollNo varchar(20)
 Declare @P_PDate smalldatetime
 Select @P_PDate=convert(varchar(10), getdate(),1)

 Select @Bank=V1.Bank, @CollNo=V2.CollNo from VAccount V1, VAccountD V2 Where V2.VID=V1.VID and V1.VID=@P_VID and V2.AccountNo=@P_Accountno

 if @CollNo<>''
	 Select @Bank as Bank, @P_AccountNo as AccountNo, '' as A_PolicyNo, Max(C.Name) as Name, 
	 @P_PDate as PDate,
	 Max(C.NDueDate) as NDueDate, 
	 Max(C.Currency) as Currency, 
	 sum(C.Amount) as Nominal, 
	 sum(C.Amount) as Outstanding, 
	 Max(C.EDate) as A_EDate,
	 Max(C.DocNo) as DocNo,
	 'For the Period of ' + convert(varchar(20), min(C.Sdate), 6) + ' - ' + convert(varchar(20), max(C.Edate), 6) as Remarks,
	 'For the Period of ' + convert(varchar(20), min(C.Sdate), 6) + ' - ' + convert(varchar(20), max(C.Edate), 6) as Description
	 from
	 (
		 Select V.Voucher, 
		 Max(V.DocNo) as DocNo,
		 Max(V.Currency) as Currency,
		 Max(Profile.Name) as Name,
		 Max(C1.CollDate) as NDueDate, Min(C1.SDate) as SDate, Max(C1.EDate) as EDate, 
		 sum(C2.Amount)-Max(Case When V.DebtorF=1 Then V.Payment_CC Else -V.Payment_CC end) as Amount
		 from CollectionH C1, CollectionV C2, CollAmount C3, nVoucher V, ProAcc, Profile
		 Where C1.RefType='VIRTUAL' and C1.Bank=@Bank and C1.AccountNo=@P_AccountNO and C1.CollStatus='R'
		 and C3.CollNo=C1.CollNo and C2.CollNo=C1.CollNo and V.Voucher=C2.Voucher and ProAcc.ProAcc=V.ProAcc and Profile.ID=ProAcc.ID
		 Group By V.Voucher
	 ) C
	 Having sum(C.Amount)>0
else	 
	 Select @Bank as Bank, @P_AccountNo as AccountNo, A.A_PolicyNo, Profile.Name, 
	 @P_PDate as PDate,
	 Max(
	 Case 
		When V.Installment=0 Then V.DueDate
		When V.Installment=1 Then V.DueDate_1
		When V.Installment>=1 and @P_PDate<V.DueDate_1 Then V.DueDate_1
		When V.Installment>=2 and @P_PDate<V.DueDate_2 Then V.DueDate_2
		When V.Installment>=3 and @P_PDate<V.DueDate_3 Then V.DueDate_3
		When V.Installment>=4 and @P_PDate<V.DueDate_4 Then V.DueDate_4
		When V.Installment>=5 and @P_PDate<V.DueDate_5 Then V.DueDate_5
		When V.Installment>=6 and @P_PDate<V.DueDate_6 Then V.DueDate_6
		When V.Installment>=7 and @P_PDate<V.DueDate_7 Then V.DueDate_7
		When V.Installment>=8 and @P_PDate<V.DueDate_8 Then V.DueDate_8
		When V.Installment>=9 and @P_PDate<V.DueDate_9 Then V.DueDate_9
		When V.Installment>=10 and @P_PDate<V.DueDate_10 Then V.DueDate_10
		When V.Installment>=11 and @P_PDate<V.DueDate_11 Then V.DueDate_11
		When V.Installment>=12 and @P_PDate<V.DueDate_12 Then V.DueDate_12
		When V.Installment>=13 and @P_PDate<V.DueDate_13 Then V.DueDate_13
		When V.Installment>=14 and @P_PDate<V.DueDate_14 Then V.DueDate_14
		When V.Installment>=15 and @P_PDate<V.DueDate_15 Then V.DueDate_15
		When V.Installment>=16 and @P_PDate<V.DueDate_16 Then V.DueDate_16
		When V.Installment>=17 and @P_PDate<V.DueDate_17 Then V.DueDate_17
		When V.Installment>=18 and @P_PDate<V.DueDate_18 Then V.DueDate_18
		When V.Installment>=19 and @P_PDate<V.DueDate_19 Then V.DueDate_19
		When V.Installment>=20 and @P_PDate<V.DueDate_20 Then V.DueDate_20
		When V.Installment>=21 and @P_PDate<V.DueDate_21 Then V.DueDate_21
		When V.Installment>=22 and @P_PDate<V.DueDate_22 Then V.DueDate_22
		When V.Installment>=23 and @P_PDate<V.DueDate_23 Then V.DueDate_23
		When V.Installment>=24 and @P_PDate<V.DueDate_24 Then V.DueDate_24
		else V.DueDate
		end) as NDueDate, 
	 Max(V.Currency) as Currency,
	 sum(
		CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
		(Case 
		When V.Installment=0 Then V.Nominal_CC-V.Diff_CC
		When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
		When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
		When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
		When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
		When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
		When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
		When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
		When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
		When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
		When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
		When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
		When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
		When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
		When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14
		When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
		When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
		When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
		When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
		When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
		When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
		When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
		When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
		When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
		When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
		else V.Nominal_CC-V.Diff_CC
		end -V.Payment_CC)) as Nominal, 
	 sum(
		CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
		(V.Nominal_CC-V.Diff_CC-V.Payment_CC)
		) as Outstanding, 
	 Max(A.A_EDate) as A_EDate,
	 Max(V.DocNo) as DocNo,
	 Max(V.Remarks) as Remarks,
	 'Policy No. ' + A.A_PolicyNo as Description
	 from 
	 (Select Distinct Voucher, ID, A_PolicyNo, A_EDate from Admlink A Where A.RefType='VIRTUAL' and A.Bank=@Bank and A.AccountNo=@P_AccountNo) A, Profile, nVoucher V
	 Where Profile.ID=A.ID and V.Voucher=A.Voucher
	 Group by Profile.Name, A.A_PolicyNo
go

--21 Oct 2020

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEBIZMAP')
BEGIN
insert into Sysform(FName,Description, FCode, RequestF) Select 'ALLOWCHANGEBIZMAP','Allow Change Bizmap (UW)','ACTIVITIES',0
end
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ETYPE' AND Object_ID = Object_ID(N'BizMap'))
begin
ALTER TABLE BizMap ADD
	ETYPE varchar(20) NULL

DECLARE @v sql_variant 
SET @v = N'Entity Type (<ANY>, INDIVIDUAL, CORPORATE)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BizMap', N'COLUMN', N'ETYPE'
end
GO


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_BizMap') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_BizMap
END
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(20) 
Declare @EType varchar(20) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @BizmapID varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
	 if @P_Source='' 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup, 
	  @BizmapID=A.BizmapID
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=A.Source)
	  Where A.ANO=@P_ANO 
	 End 
	 Else 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=@P_Source)
	  Where A.ANO=@P_ANO 
	 End 
End 
ELSE 
BEGIN 
	SELECT 
		@CType=Source.CType, 
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
		@EType=Case When Source.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
		@Source_LOB=Source.LOB, 
		@Segment='DIRECT', 
	    @ISType='I' 
	from Profile Source 
	Where Source.ID=@P_Source	 
END 
 
Select Top 1 @ID=B.ID 
from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (EType='<ANY>' or EType=@EType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=@SegmentGroup) 
Order By OrderNo, ID 

return(coalesce(@ID,@BizMapID)) 
End 




go
--16 OCt 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NoGDiscountF' AND Object_ID = Object_ID(N'PayorDet'))
begin
ALTER TABLE PayorDet ADD
	NoGDiscountF Bit NULL

DECLARE @v sql_variant 
SET @v = N'Apply No Group Discount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PayorDet', N'COLUMN', N'NoGDiscountF'
end
GO


GO
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NoGDiscountF' AND Object_ID = Object_ID(N'APayorDet'))
begin
ALTER TABLE APayorDet ADD
	NoGDiscountF float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Apply No Group Discount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APayorDet', N'COLUMN', N'NoGDiscountF'
end
GO


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Payor_Discount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Payor_Discount
END
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
 Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(50)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
 Declare @OANO int
 Declare @DiscAmount Float
 Declare @Gross Float
 Declare @NoGDiscountF Bit

Select @TDiscount=Null
Select @PDiscount=Null
Select @GDiscount=0
Select @NDiscount=0
Select @SLoading=0
Select @DiscAmount=0
Select @NoGDiscountF=0
                 
Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO, @Gross=PCalc.Gross from Acceptance, PCalc Where Pcalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @DiscAmount=Payor.DiscAmount, @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
         from Acceptance 
         Left Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
         -- Payor Discount from Alternate Discount          
        Select @DiscAmount=APayor.DiscAmount, @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @DiscAmount=coalesce(PayorDet.DiscAmount, Payor.DiscAmount), @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
        End          
        Else          
        BEGIN          
             Select @DiscAmount=PayorDet.DiscAmount, @TDiscount=PayorDet.Discount, @NoGDiscountF=coalesce(PayorDet.NoGDiscountF,0)
			 from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
        End          
 END
                        
 if @TDiscount is not null          
		Select @PDiscount=@TDiscount          

 if @NoGDiscountF=1
	Select @GDiscount=0

 if @PDiscount=0 and @DiscAmount<>0
	Select @PDiscount=@DiscAmount / (@Gross * (1 - @GDiscount / 100) * (1 - @NDiscount / 100)) * 100

 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          


go


--update 23 Oct 2020 : PENAMBAHAN OPSI PERIODLIST UNTUK NCPERIOD
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NCPERIODINDAYSF' AND Object_ID = Object_ID(N'TOP_Rate'))
begin
ALTER TABLE TOP_Rate ADD
	NCPERIODINDAYSF bit NULL

DECLARE @v sql_variant 
SET @v = N'NO CLAIM PERIOD OPTION (0 : IN MONTH, 1 : IN DAY)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'NCPERIODINDAYSF'
end
GO



-- index apdbukcet

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='APDRuleD' AND CONSTRAINT_NAME='I_APDRuleD')
Begin
ALTER TABLE [APDRuleD] DROP CONSTRAINT [I_APDRuleD]
END
GO


ALTER TABLE [APDRuleD] ALTER COLUMN version varchar(50) NOT NULL
GO
ALTER TABLE [APDRuleD] ALTER COLUMN [PrintLogoF] BIT NOT NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='APDRuleD' AND CONSTRAINT_NAME='I_APDRuleD')
Begin
ALTER TABLE [APDRuleD] ADD  CONSTRAINT [I_APDRuleD] PRIMARY KEY CLUSTERED 
(
	[RuleID] ASC,
	[Class] ASC,
	[version] ASC,
	[PrintLogoF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO


--4 Nov 2020
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BSOPEXDET]') AND type in (N'U'))
begin
CREATE TABLE [BSOPEXDET](
	[ObjID] [int] NOT NULL,
	[TOC] [varchar](10) NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[AMOUNTPCT] Float Null,
	[FLDID1] [varchar](10) NULL,
	[VALUEID1] [varchar](15) NULL,
	[VALUEDESC1] [varchar](255) NULL,
	[FLDID2] [varchar](10) NULL,
	[VALUEID2] [varchar](15) NULL,
	[VALUEDESC2] [varchar](255) NULL,
	[FLDID3] [varchar](10) NULL,
	[VALUEID3] [varchar](15) NULL,
	[VALUEDESC3] [varchar](255) NULL,
	[FLDID4] [varchar](10) NULL,
	[VALUEID4] [varchar](15) NULL,
	[VALUEDESC4] [varchar](255) NULL,
	[FLDID5] [varchar](10) NULL,
	[VALUEID5] [varchar](15) NULL,
	[VALUEDESC5] [varchar](255) NULL,
	[FLDID6] [varchar](10) NULL,
	[VALUEID6] [varchar](15) NULL,
	[VALUEDESC6] [varchar](255) NULL,
	[FLDID7] [varchar](10) NULL,
	[VALUEID7] [varchar](15) NULL,
	[VALUEDESC7] [varchar](255) NULL,
	[FLDID8] [varchar](10) NULL,
	[VALUEID8] [varchar](15) NULL,
	[VALUEDESC8] [varchar](255) NULL,
	[FLDID9] [varchar](10) NULL,
	[VALUEID9] [varchar](15) NULL,
	[VALUEDESC9] [varchar](255) NULL,
	[FLDID10] [varchar](10) NULL,
	[VALUEID10] [varchar](15) NULL,
	[VALUEDESC10] [varchar](255) NULL,
	[FLDID11] [varchar](10) NULL,
	[VALUEID11] [varchar](15) NULL,
	[VALUEDESC11] [varchar](255) NULL,
	[FLDID12] [varchar](10) NULL,
	[VALUEID12] [varchar](15) NULL,
	[VALUEDESC12] [varchar](255) NULL,
	[FLDID13] [varchar](10) NULL,
	[VALUEID13] [varchar](15) NULL,
	[VALUEDESC13] [varchar](255) NULL,
	[FLDID14] [varchar](50) NULL,
	[VALUEID14] [varchar](15) NULL,
	[VALUEDESC14] [varchar](255) NULL,
	[FLDID15] [varchar](10) NULL,
	[VALUEID15] [varchar](15) NULL,
	[VALUEDESC15] [varchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[PriorityF] [Bit] Null
 CONSTRAINT [I_BSOPEXDET] PRIMARY KEY CLUSTERED 
(
	[ObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



SET ANSI_PADDING OFF


ALTER TABLE [BSOPEXDET]  WITH NOCHECK ADD  CONSTRAINT [FK_BSOPEXDET_TOC] FOREIGN KEY([TOC])
REFERENCES [dbo].[TOC] ([TOC])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [BSOPEXDET] CHECK CONSTRAINT [FK_BSOPEXDET_TOC]

CREATE INDEX I_BSOPEXDET_TOC_ID on BSOPEXDET(TOC,ID)
end
go

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_BSOPEX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_BSOPEX
END
GO
CREATE Procedure QGet_BSOPEX(@P_ANO as integer, @P_TOC as varchar(10), @P_Source as varchar(10))
AS
SELECT top 1 BSOPEX.ID, BSOPEX.FDID, BSOPEX.REMARK, BSOPEX.CURRENCY, BSOPEX.AMOUNT, coalesce(BSOPEXDET.AMOUNTPCT, BSOPEX.AMOUNTPCT) AS AMOUNTPCT, BSOPEX.AMOUNTPCTBASED 
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join BSOPEX on (BSOPEX.TOC=@P_TOC and BSOPEX.ID=@P_SOURCE)
Left Join BSOPEXDET on (
	BSOPEXDET.TOC=@P_TOC and BSOPEXDET.ID=@P_SOURCE
	And ((BSOPEXDET.ValueID1='' and Ainfo.ValueDesc1 Like BSOPEXDET.ValueDesc1+'%') or (BSOPEXDET.ValueID1<>'' and AInfo.ValueID1 Like BSOPEXDET.ValueID1+'%') or (BSOPEXDET.ValueID1 is null))                    
	And ((BSOPEXDET.ValueID2='' and Ainfo.ValueDesc2 Like BSOPEXDET.ValueDesc2+'%') or (BSOPEXDET.ValueID2<>'' and AInfo.ValueID2 Like BSOPEXDET.ValueID2+'%') or (BSOPEXDET.ValueID2 is null))                    
	And ((BSOPEXDET.ValueID3='' and Ainfo.ValueDesc3 Like BSOPEXDET.ValueDesc3+'%') or (BSOPEXDET.ValueID3<>'' and AInfo.ValueID3 Like BSOPEXDET.ValueID3+'%') or (BSOPEXDET.ValueID3 is null))                    
	And ((BSOPEXDET.ValueID4='' and Ainfo.ValueDesc4 Like BSOPEXDET.ValueDesc4+'%') or (BSOPEXDET.ValueID4<>'' and AInfo.ValueID4 Like BSOPEXDET.ValueID4+'%') or (BSOPEXDET.ValueID4 is null))                    
	And ((BSOPEXDET.ValueID5='' and Ainfo.ValueDesc5 Like BSOPEXDET.ValueDesc5+'%') or (BSOPEXDET.ValueID5<>'' and AInfo.ValueID5 Like BSOPEXDET.ValueID5+'%') or (BSOPEXDET.ValueID5 is null))                    
	And ((BSOPEXDET.ValueID6='' and Ainfo.ValueDesc6 Like BSOPEXDET.ValueDesc6+'%') or (BSOPEXDET.ValueID6<>'' and AInfo.ValueID6 Like BSOPEXDET.ValueID6+'%') or (BSOPEXDET.ValueID6 is null))                    
	And ((BSOPEXDET.ValueID7='' and Ainfo.ValueDesc7 Like BSOPEXDET.ValueDesc7+'%') or (BSOPEXDET.ValueID7<>'' and AInfo.ValueID7 Like BSOPEXDET.ValueID7+'%') or (BSOPEXDET.ValueID7 is null))                    
	And ((BSOPEXDET.ValueID8='' and Ainfo.ValueDesc8 Like BSOPEXDET.ValueDesc8+'%') or (BSOPEXDET.ValueID8<>'' and AInfo.ValueID8 Like BSOPEXDET.ValueID8+'%') or (BSOPEXDET.ValueID8 is null))                    
	And ((BSOPEXDET.ValueID9='' and Ainfo.ValueDesc9 Like BSOPEXDET.ValueDesc9+'%') or (BSOPEXDET.ValueID9<>'' and AInfo.ValueID9 Like BSOPEXDET.ValueID9+'%') or (BSOPEXDET.ValueID9 is null))                    
	And ((BSOPEXDET.ValueID10='' and Ainfo.ValueDesc10 Like BSOPEXDET.ValueDesc10+'%') or (BSOPEXDET.ValueID10<>'' and AInfo.ValueID10 Like BSOPEXDET.ValueID10+'%') or (BSOPEXDET.ValueID10 is null))                    
	And ((BSOPEXDET.ValueID11='' and Ainfo.ValueDesc11 Like BSOPEXDET.ValueDesc11+'%') or (BSOPEXDET.ValueID11<>'' and AInfo.ValueID11 Like BSOPEXDET.ValueID11+'%') or (BSOPEXDET.ValueID11 is null))                    
	And ((BSOPEXDET.ValueID12='' and Ainfo.ValueDesc12 Like BSOPEXDET.ValueDesc12+'%') or (BSOPEXDET.ValueID12<>'' and AInfo.ValueID12 Like BSOPEXDET.ValueID12+'%') or (BSOPEXDET.ValueID12 is null))                    
	And ((BSOPEXDET.ValueID13='' and Ainfo.ValueDesc13 Like BSOPEXDET.ValueDesc13+'%') or (BSOPEXDET.ValueID13<>'' and AInfo.ValueID13 Like BSOPEXDET.ValueID13+'%') or (BSOPEXDET.ValueID13 is null))                    
	And ((BSOPEXDET.ValueID14='' and Ainfo.ValueDesc14 Like BSOPEXDET.ValueDesc14+'%') or (BSOPEXDET.ValueID14<>'' and AInfo.ValueID14 Like BSOPEXDET.ValueID14+'%') or (BSOPEXDET.ValueID14 is null))     
	And ((BSOPEXDET.ValueID15='' and Ainfo.ValueDesc15 Like BSOPEXDET.ValueDesc15+'%') or (BSOPEXDET.ValueID15<>'' and AInfo.ValueID15 Like BSOPEXDET.ValueID15+'%') or (BSOPEXDET.ValueID15 is null))      
)
WHERE Acceptance.ANO=@P_ANO
Order by coalesce(BSOPEXDET.PriorityF,0) Desc
go

--Update 2020 v.1.2.1
--16 Nov 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankersID' AND Object_ID = Object_ID(N'ACCEPTANCE'))
begin
ALTER TABLE ACCEPTANCE ADD
	BankersID varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'see Profile ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'BankersID'
end
GO


--21 October 2020 : Penambahan Parent Sub Company Group
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Parent' AND Object_ID = Object_ID(N'SCGroup'))
begin
ALTER TABLE SCGroup ADD
	Parent varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Parent Sub Company Group'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SCGroup', N'COLUMN', N'Parent'
end
GO


--17 Nov 2020 : Penmabahann Partial Payment Cash Call
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CashCallOnPartialPaymentF' AND Object_ID = Object_ID(N'TOC'))
begin
ALTER TABLE TOC ADD
	CashCallOnPartialPaymentF bit NULL

DECLARE @v sql_variant 
SET @v = N'Cash Call on Partial Payment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CashCallOnPartialPaymentF'
end
GO


go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetIndemnityClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGetIndemnityClaimForCashCall
END
GO
Create Procedure QGetIndemnityClaimForCashCall(@P_CNO as integer)                  
as     
Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+CCalc.RCost)) 
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+pCCalc.RCost),0)) 
as Indemnity 
from CCalc 
Inner Join Claim on (Claim.CNO=CCalc.CNO)
Inner Join TOC on (TOC.TOC=Claim.TOC)
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)
Where CCALC.CNO=@P_CNO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionIndemnityClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGetConjunctionIndemnityClaimForCashCall

END
GO
Create Procedure QGetConjunctionIndemnityClaimForCashCall(@P_CNO as integer)
as

Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+CCalc.RCost)) 
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+pCCalc.RCost),0)) 
as Indemnity 
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner join Claim C2 ON (C2.ANO=A2.ANO and C2.CType<>'C' and (C2.CStatus='A' or C2.pCStatus='A'))
Inner Join CCalc on (CCALC.CNO=C2.CNO)
Inner Join TOC on (TOC.TOC=C2.TOC)
Left Join CCalc pCCalc on (pCCalc.CNO=C2.pCNO and pCCalc.Currency=CCalc.Currency and C2.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)
Where C1.CNO=@P_CNO 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW06B') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW06B 
END
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE,
pC.CAMOUNT as PREVCAMOUNT, pc.XPAMOUNT as PREVXPAMOUNT, pC.DAmount as PREVDAmount, pC.QAMOUNT as PREVQAMOUNT, pC.SP1AMOUNT as PREVSP1AMOUNT, pC.SP2AMOUNT as PREVSP2AMOUNT, pC.SP3AMOUNT as PREVSP3AMOUNT, pC.AAmount as PREVAAmount, pC.FAmount as PrevFAmount,
pc.XL1AMOUNT as PREVXL1AMOUNT, pc.XL2AMOUNT as PREVXL2AMOUNT, pc.XL3AMOUNT as PREVXL3AMOUNT,pc.XL4AMOUNT as PREVXL4AMOUNT,pc.XL5AMOUNT as PREVXL5AMOUNT,pc.XL6AMOUNT as PREVXL6AMOUNT,pc.XL7AMOUNT as PREVXL7AMOUNT,pC.QXOLAMOUNT as PREVQXOLAMOUNT, pc.RAMOUNT as PREVRAMOUNT,
TOC.CashCallOnPartialPaymentF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
INNER JOIN CARRHEADER C ON (C.CNO=CLAIM.CNO)
INNER JOIN RARRHEADER R ON (R.ANO=ACCEPTANCE.ANO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
LEFT JOIN CARRHEADER pC ON (pC.CNO=CLAIM.pCNO and CLAIM.CSEQNO>0)
WHERE CLAIM.CNO=@P_CNO 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_To_Adm
END
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, 
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
Case When TOC.CashCallOnPartialPaymentF=0 Then C1.CashLossF else cast(0 as Bit) end as CashCallGroup,
cast(Max(
	cast(
		Case 
			When TOC.CashCallOnPartialPaymentF=0 Then C1.CashLossF 
			Else Case When C1.CAmount=0 Then cast(0 as Bit) else C1.CashLossF End
		End
	as integer)
	) 
as Bit) as CashLossF,
sum(Case When C1.Code='P' then C1.Amount else 0 end) as Amount_1,                              
sum(Case When C1.Code='A' then C1.Amount else 0 end) as Amount_6,                              
sum(Case When C1.Code='E' then C1.Amount else 0 end) as Amount_7,                              
sum(Case When C1.Code='S' then C1.Amount else 0 end) as Amount_8,                              
sum(Case When C1.Code='L' then C1.Amount else 0 end) as Amount_9,                              
sum(Case When C1.Code='R' then C1.Amount else 0 end) as Amount_10,                              
sum(Case When C1.Code='V' then C1.Amount else 0 end) as Amount_13,                              
sum(Case When C1.Code='T' then C1.Amount else 0 end) as Amount_14,                              
sum(Case When C1.Code='F' then C1.Amount else 0 end) as Amount_15,                              
sum(Case When C1.Code='D' then C1.Amount else 0 end) as Amount_16,                              
sum(Case When C1.Code='I' then C1.Amount else 0 end) as Amount_17
from ClaAss C1
INNER JOIN CLAIM C2 on (C2.CNO=C1.CNO)
INNER JOIN TOC on (TOC.TOC=C2.TOC)
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.CNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) CLCOST ON (C1.CAMOUNT<>0 AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.PCNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) PCLCOST ON (C1.CAMOUNT=0 AND PCLCOST.CNO=C2.PCNO AND PCLCOST.ID=C1.ID AND CASE WHEN PCLCOST.REFNO<>'' THEN PCLCOST.REFNO ELSE PC2.REFNO END=C1.REFNO AND PCLCOST.CURRENCY=C1.CURRENCY)
Where C1.CNO=@P_CNO
Group by C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, Case When TOC.CashCallOnPartialPaymentF=0 Then C1.CashLossF else cast(0 as Bit) end









go

--17 Nov 2020 (1) : Penambah Collateral Deposit
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CashDepositF' AND Object_ID = Object_ID(N'COLLATERALTYPE'))
begin
ALTER TABLE COLLATERALTYPE ADD
	CashDepositF bit NULL

DECLARE @v sql_variant 
SET @v = N'Cash Deposit Flag (0 : No, 1 : Yes); if Deposit Flag Yes, will Create DN/CN'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLATERALTYPE', N'COLUMN', N'CashDepositF'
end
GO



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCCOLLATERALCASHDEPOSIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QACCCOLLATERALCASHDEPOSIT 
END
GO
CREATE Procedure QACCCOLLATERALCASHDEPOSIT (@P_ANO integer)
as

Select D.ID, D.Currency, sum(D.Nominal) as Nominal
from 
(

Select A2.ID, A2.Currency, sum(A2.Nominal) as Nominal
from Acceptance A1
INNER JOIN ACCCOLLATERAL A2 on (A2.ANO=A1.OANO)
INNER JOIN COLLATERALTYPE C on (C.COLLATERALTYPE=A2.COLLATERALTYPE and C.CashDepositF=1)
Where A1.ANO=@P_ANO
Group by A2.ID, A2.Currency

Union All

Select A3.ID, A3.Currency, -sum(A3.Amount) as Nominal
from Acceptance A1
Inner join Acceptance A2 on (A2.OANO=A1.OANO and A2.ANO<=A1.ANO)
Inner Join AccAss A3 on (A3.ANO=A2.ANO and A3.Type='DR')
Where A1.ANO=@P_ANO
Group by A3.ID, A3.Currency

) D
Group by D.ID, D.Currency

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCCOLLATERALLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QACCCOLLATERALLIST
END
GO
CREATE PROCEDURE QACCCOLLATERALLIST(@P_OANO as Integer)    
AS    
SELECT cast(0 as Bit) as ProcessFlag, A.COLLATERALNO, A.COLLATERALTYPE, A.DOCNO, A.DESCRIPTION, A.CURRENCY, A.NOMINAL, A.REMARKS, C2.AMOUNT AS RECOVERED, C.CashDepositF
FROM ACCCOLLATERAL A   
LEFT JOIN COLLATERALTYPE C on (C.COLLATERALTYPE=A.COLLATERALTYPE)
LEFT JOIN (
	SELECT A1.OANO, C1.ITEM, C3.CURRENCY, sum(C1.AMOUNT) AS AMOUNT 
	FROM CLSUBDET C1, CLAIM C2, CLSUB C3, ACCEPTANCE A1 
	WHERE A1.ANO=C2.ANO AND C1.CNO=C2.CNO AND C3.CNO=C1.CNO AND C3.ID=C1.ID AND C3.CURRENCY=C1.CURRENCY AND C3.REFNO=C1.REFNO
	AND C2.CType<>'C' AND (C2.CStatus<>'C' or C2.PCStatus='A') and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
	AND C3.STATUS='P' AND A1.OANO=@P_OANO
	GROUP BY A1.OANO, C1.ITEM, C3.CURRENCY
	) C2  ON (A.ANO=C2.OANO AND A.COLLATERALNO=C2.ITEM AND A.CURRENCY=C2.CURRENCY)    
WHERE A.ANO=@P_OANO 

GO

delete from Mparam Where Type in ('DR','DP')
GO
insert into MParam (Type, Remarks, VAT, Pasal21, Pasal23, Pasal26, TaxDiscount, MemorialF, Effective, Pasal21OLD, PASAL23OLD, PASAL26OLD, Last_Opr, Last_Update)
Select 'DR','Cash Deposit Receipt', 0,0,0,0,0,1,'01/01/2009',0,0,0,'CARE','11/17/2020'
GO
insert into MParam (Type, Remarks, VAT, Pasal21, Pasal23, Pasal26, TaxDiscount, MemorialF, Effective, Pasal21OLD, PASAL23OLD, PASAL26OLD, Last_Opr, Last_Update)
Select 'DP','Cash Deposit Payment', 0,0,0,0,0,1,'01/01/2009',0,0,0,'CARE','11/17/2020'

go


--23 Nov 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LUserID' AND Object_ID = Object_ID(N'ACCFD'))
begin
ALTER TABLE ACCFD ADD
	LUserID varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LDate' AND Object_ID = Object_ID(N'ACCFD'))
begin
ALTER TABLE ACCFD ADD
	LDate smalldatetime NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoGeneratedF' AND Object_ID = Object_ID(N'ACCFD'))
begin
ALTER TABLE ACCFD ADD
	AutoGeneratedF bit NULL

DECLARE @v sql_variant 
SET @v = N'Auto Generated by System (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCFD', N'COLUMN', N'AutoGeneratedF'
end
GO


GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEAUTOGENERATEDDATA')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGEAUTOGENERATEDDATA','Allow Change Auto Generated Data','ACTIVITIES',0
end
Go

--24 Nov 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CedingID' AND Object_ID = Object_ID(N'ISOURCE'))
begin
ALTER TABLE ISOURCE ADD
	CedingID varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Ceding Profile ID (if Insurance Source ID is not a Ceding Company)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ISOURCE', N'COLUMN', N'CedingID'
end
GO



--25 Nov 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'InclAddInterestF' AND Object_ID = Object_ID(N'Scheme_Coverage'))
begin
ALTER TABLE Scheme_Coverage ADD
	InclAddInterestF bit NULL

DECLARE @v sql_variant 
SET @v = N'if the Risk Coverage Rate include Rate for Additional Interest (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Coverage', N'COLUMN', N'InclAddInterestF'
end
GO



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QScheme_Verify_2
END
GO
CREATE Procedure QScheme_Verify_2 
@p_Coverage as varchar (255), 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 
 
Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from Scheme_Class S Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by Priority Desc 
 
Select 
S1.ClassNo, 
S1.Coverage, 
S1.Code, 
S1.Rate, 
S1.GrossUpF, 
S1.Unit, 
S1.Category, 
S1.Portion, 
S1.RateLoadingF, 
S1.InclAddInterestF,
RateTab.Description 
from 
Scheme_Coverage S1, RateTab 
Where 
S1.ClassNo=@p_ClassNo 
and S1.Coverage=@p_Coverage 
and RateTab.Code=S1.Code 
 
 

go

--28 Nov 2020

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Limit' AND Object_ID = Object_ID(N'TOP_PHOLDER'))
begin
ALTER TABLE TOP_PHOLDER ADD
	Limit float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Max Liability (0 : Not Applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_PHOLDER', N'COLUMN', N'Limit'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Limit' AND Object_ID = Object_ID(N'TOP_INSURED'))
begin
ALTER TABLE TOP_INSURED ADD
	Limit float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Max Liability (0 : Not Applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_INSURED', N'COLUMN', N'Limit'
end
GO



GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='EXCEEDINGPRODUCTLIMIT')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'EXCEEDINGPRODUCTLIMIT','Allow Exceed Product (Pholder) Limit','ACTIVITIES',0
end
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetTotalSumInsuredByProductAndPHolder') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetTotalSumInsuredByProductAndPHolder
END
GO
CREATE Function fn_GetTotalSumInsuredByProductAndPHolder(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_PHolder as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance, Cover
		Where Cover.CNO=Acceptance.CNO 
		and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Cover.PHolder=@P_PHolder 
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetTotalSumInsuredByProductAndInsured') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetTotalSumInsuredByProductAndInsured
END
GO
CREATE Function fn_GetTotalSumInsuredByProductAndInsured(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_AID as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance, Cover
		Where Cover.CNO=Acceptance.CNO 
		and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.AID=@P_AID
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RateLoading') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_RateLoading
END
GO
CREATE Function Get_RateLoading(@P_ANO as int,@P_Code as varchar(20), @P_PDate as datetime, @P_TSI as Float) 
RETURNS @RateCon TABLE (Loading Float, HoldF bit, HoldMessage varchar(512), CID varchar(512), AggregateTSI Float, SRate Float)   
AS     
BEGIN       
Declare @SPeriod Int
Declare @SDate smalldatetime
Declare @EDate smalldatetime
Declare @TOPRO varchar(10)
Declare @PHolder varchar(10)
Declare @AID varchar(10)
Declare @CheckRateConSIBy int
Declare @OANO Int
Declare @REGID varchar(10)
Declare @FLDID varchar(255)
Declare @VALUEID varchar(255)
Declare @AgeMethod Int


Declare @RateTab Table (
ValueID1 varchar(15),
ValueID2 varchar(15),
ValueID3 varchar(15),
ValueID4 varchar(15),
ValueID5 varchar(15),
ValueID6 varchar(15),
ValueID7 varchar(15),
ValueID8 varchar(15),
ValueID9 varchar(15),
ValueID10 varchar(15),
ValueID11 varchar(15),
ValueID12 varchar(15),
ValueID13 varchar(15),
ValueID14 varchar(15),
ValueID15 varchar(15)
)

Declare @Loading as Float
Declare @HoldF as Bit
Declare @HoldMessage as varchar(512)
Declare @CID as varchar(512)
Declare @SRate as Float
Declare @Prorata as int
Declare @PPeriod as int
Declare @ExclusiveF as bit
Declare @STime as varchar(10)
Declare @ETime as varchar(10)

Select @Loading=1
Select @HoldF=0
Select @HoldMessage=''
Select @CID=''
Select @SRate=0


Select @AgeMethod=TOC.AgeMethod, @OANO=A.OANO, @RegID=A.RegID, @FLDID=A.FLDID, @ValueID=A.ValueID, @PHolder=C.PHolder, @AID=A.AID, @SDate=@P_PDate, @EDate=A.EDate, @TOPRO=A.TOPRO, @CheckRateConSIBy=coalesce(T.CheckRateConSIBy,0), @SPeriod=RateTab.SPeriod, @Prorata=C.
PRORATA, @PPERIOD=C.PPERIOD, @ExclusiveF=A.EXCLUSIVEF, @STime=A.STime, @ETime=A.ETime
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO) Inner Join TOC on (TOC.TOC=A.TOC) Left Join TOPRO T on (T.TOPRO=A.TOPRO), RateTab
Where A.ANO=@P_ANO and RateTab.Code=@P_Code

Select @P_TSI=@P_TSI+case 
	When @CheckRateConSIBy=1 Then dbo.fn_GetTotalSumInsuredByProduct(@P_PDate,@TOPRO,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=2 Then dbo.fn_GetTotalSumInsuredByPHolder(@P_PDate,@PHolder,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=3 Then dbo.fn_GetTotalSumInsured(@P_PDate,@RegID, @FLDID, @VALUEID,@OANO)
	When @CheckRateConSIBy=4 Then dbo.fn_GetTotalSumInsuredByProductAndPHolder(@P_PDate,@TOPRO, @PHolder, @OANO)
	When @CheckRateConSIBy=5 Then dbo.fn_GetTotalSumInsuredByProductAndInsured(@P_PDate,@TOPRO, @AID, @OANO)	
	else 0
	end

insert into @RateTab
SELECT Top 1 
coalesce(G1.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID1 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc1,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H1.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc1) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID1,
coalesce(G2.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID2 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc2,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H2.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc2) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID2,
coalesce(G3.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID3 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc3,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H3.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc3) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID3,
coalesce(G4.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID4 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc4,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H4.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc4) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID4,
coalesce(G5.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID5 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc5,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H5.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc5) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID5,
coalesce(G6.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID6 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc6,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H6.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc6) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID6,
coalesce(G7.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID7 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc7,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H7.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc7) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID7,
coalesce(G8.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID8 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc8,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H8.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc8) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID8,
coalesce(G9.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID9 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc9,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H9.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc9) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID9,
coalesce(G10.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID10 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc10,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H10.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc10) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID10,
coalesce(G11.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID11 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc11,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H11.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc11) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID11,
coalesce(G12.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID12 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc12,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H12.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc12) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID12,
coalesce(G13.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID13 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc13,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H13.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc13) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID13,
coalesce(G14.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID14 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc14,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H14.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc14) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID14,
coalesce(G15.ValueID,(Select Top 1 G.ValueID from GendTab G Where G.FLDID=AInfo.FLDID15 and ((G.Formula='AGE' and dbo.fn_Age(AInfo.ValueDesc15,@P_PDate, Case When @AgeMethod>=0 then @AgeMethod else H15.AgeMethod end) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper)) or (G.Formula='VALUE' and dbo.fn_toval(AInfo.ValueDesc15) between dbo.fn_toval(G.FLower) and dbo.fn_toval(G.FUpper))))) as ValueID15
From AINFO
 INNER JOIN RateTab ON (RateTab.Code=@P_Code)     
 Left Join GenHTab H1 on (H1.FLDID=AInfo.FLDID1)
 Left Join GenHTab H2 on (H2.FLDID=AInfo.FLDID2)
 Left Join GenHTab H3 on (H3.FLDID=AInfo.FLDID3)
 Left Join GenHTab H4 on (H4.FLDID=AInfo.FLDID4)
 Left Join GenHTab H5 on (H5.FLDID=AInfo.FLDID5)
 Left Join GenHTab H6 on (H6.FLDID=AInfo.FLDID6)
 Left Join GenHTab H7 on (H7.FLDID=AInfo.FLDID7)
 Left Join GenHTab H8 on (H8.FLDID=AInfo.FLDID8)
 Left Join GenHTab H9 on (H9.FLDID=AInfo.FLDID9)
 Left Join GenHTab H10 on (H10.FLDID=AInfo.FLDID10)
 Left Join GenHTab H11 on (H11.FLDID=AInfo.FLDID11)
 Left Join GenHTab H12 on (H12.FLDID=AInfo.FLDID12)
 Left Join GenHTab H13 on (H13.FLDID=AInfo.FLDID13)
 Left Join GenHTab H14 on (H14.FLDID=AInfo.FLDID14)
 Left Join GenHTab H15 on (H15.FLDID=AInfo.FLDID15)           
 Left Join GenDTab G1 on (H1.FLDTAB=1 and G1.FLDID=AInfo.FLDID1 and G1.ValueID=AInfo.ValueID1)
 Left Join GenDTab G2 on (H2.FLDTAB=1 and G2.FLDID=AInfo.FLDID2 and G2.ValueID=AInfo.ValueID2)
 Left Join GenDTab G3 on (H3.FLDTAB=1 and G3.FLDID=AInfo.FLDID3 and G3.ValueID=AInfo.ValueID3)
 Left Join GenDTab G4 on (H4.FLDTAB=1 and G4.FLDID=AInfo.FLDID4 and G4.ValueID=AInfo.ValueID4)
 Left Join GenDTab G5 on (H5.FLDTAB=1 and G5.FLDID=AInfo.FLDID5 and G5.ValueID=AInfo.ValueID5)
 Left Join GenDTab G6 on (H6.FLDTAB=1 and G6.FLDID=AInfo.FLDID6 and G6.ValueID=AInfo.ValueID6)
 Left Join GenDTab G7 on (H7.FLDTAB=1 and G7.FLDID=AInfo.FLDID7 and G7.ValueID=AInfo.ValueID7)
 Left Join GenDTab G8 on (H8.FLDTAB=1 and G8.FLDID=AInfo.FLDID8 and G8.ValueID=AInfo.ValueID8)
 Left Join GenDTab G9 on (H9.FLDTAB=1 and G9.FLDID=AInfo.FLDID9 and G9.ValueID=AInfo.ValueID9)
 Left Join GenDTab G10 on (H10.FLDTAB=1 and G10.FLDID=AInfo.FLDID10 and G10.ValueID=AInfo.ValueID10)
 Left Join GenDTab G11 on (H11.FLDTAB=1 and G11.FLDID=AInfo.FLDID11 and G11.ValueID=AInfo.ValueID11)
 Left Join GenDTab G12 on (H12.FLDTAB=1 and G12.FLDID=AInfo.FLDID12 and G12.ValueID=AInfo.ValueID12)
 Left Join GenDTab G13 on (H13.FLDTAB=1 and G13.FLDID=AInfo.FLDID13 and G13.ValueID=AInfo.ValueID13)
 Left Join GenDTab G14 on (H14.FLDTAB=1 and G14.FLDID=AInfo.FLDID14 and G14.ValueID=AInfo.ValueID14)
 Left Join GenDTab G15 on (H15.FLDTAB=1 and G15.FLDID=AInfo.FLDID15 and G15.ValueID=AInfo.ValueID15)
WHERE AINFO.ANO=@P_ANO                       

Declare @Temp_Loading as Float
Declare @Temp_HoldF as Bit
Declare @Temp_HoldMessage as varchar(512)
Declare @Temp_CID as varchar(512)
Declare @Temp_SRate as Float

--Rate Loading #1
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M1 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)             
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 
	
--Rate Loading #2
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M2 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)   
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,      
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #3
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M3 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #4
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M4 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)             
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                        
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #5
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M5 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)      
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #6
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M6 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)              
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)                
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,                          
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

--Rate Loading #7
Select @Temp_Loading=Null
Select @Temp_HoldF=Null
Select @Temp_HoldMessage=Null
Select @Temp_CID=Null
Select @Temp_SRate=Null

SELECT Top 1 @Temp_Loading=RateCon.Loading, @Temp_HoldF=RateCon.HoldF, @Temp_HoldMessage=RateCon.HoldMessage, @Temp_CID=RateCon.CID, @Temp_SRate=RateCon.SRate
From @RateTab RateTab
INNER JOIN RateCon_M7 RateCon  on (
RateCon.Code=@P_Code and RateCon.AllowedF=1                 
And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) 
and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
And (
	 (@SPeriod=0 and (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)>=RateCon.MinPeriod)     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (ceiling(dbo.fn_Premium_Calc_Prorata(@SDate, case When @ExclusiveF=0 and @STime<@ETime Then dateadd(day,1,@EDate) else @EDate End,@Prorata,12,CASE WHEN @PPeriod=1 Then 0 ELSE @PPeriod END)*12)<=RateCon.MaxPeriod)     
	 or RateCon.MaxPeriod=0)) OR
	(@SPeriod=1 
	 and ((datediff(day, @SDate, @EDate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, @SDate, @EDate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
and (coalesce(RateCon.ValueID1,'')='' or RateTab.ValueID1 =RateCon.ValueID1)                
And (coalesce(RateCon.ValueID2,'')='' or RateTab.ValueID2 =RateCon.ValueID2)                
And (coalesce(RateCon.ValueID3,'')='' or RateTab.ValueID3 =RateCon.ValueID3)                
And (coalesce(RateCon.ValueID4,'')='' or RateTab.ValueID4 =RateCon.ValueID4)                
And (coalesce(RateCon.ValueID5,'')='' or RateTab.ValueID5 =RateCon.ValueID5)                
And (coalesce(RateCon.ValueID6,'')='' or RateTab.ValueID6 =RateCon.ValueID6)                
And (coalesce(RateCon.ValueID7,'')='' or RateTab.ValueID7 =RateCon.ValueID7)           
And (coalesce(RateCon.ValueID8,'')='' or RateTab.ValueID8 =RateCon.ValueID8)                
And (coalesce(RateCon.ValueID9,'')='' or RateTab.ValueID9 =RateCon.ValueID9)                
And (coalesce(RateCon.ValueID10,'')='' or RateTab.ValueID10 =RateCon.ValueID10)                
And (coalesce(RateCon.ValueID11,'')='' or RateTab.ValueID11 =RateCon.ValueID11)                
And (coalesce(RateCon.ValueID12,'')='' or RateTab.ValueID12 =RateCon.ValueID12)                
And (coalesce(RateCon.ValueID13,'')='' or RateTab.ValueID13 =RateCon.ValueID13)                
And (coalesce(RateCon.ValueID14,'')='' or RateTab.ValueID14 =RateCon.ValueID14)                
And (coalesce(RateCon.ValueID15,'')='' or RateTab.ValueID15 =RateCon.ValueID15)                       
)
Order by   
len(coalesce(RateCon.ValueID1,'')) Desc,                           
len(coalesce(RateCon.ValueID2,'')) Desc,                           
len(coalesce(RateCon.ValueID3,'')) Desc,                           
len(coalesce(RateCon.ValueID4,'')) Desc,                           
len(coalesce(RateCon.ValueID5,'')) Desc,    
len(coalesce(RateCon.ValueID6,'')) Desc,                          
len(coalesce(RateCon.ValueID7,'')) Desc,                          
len(coalesce(RateCon.ValueID8,'')) Desc,                          
len(coalesce(RateCon.ValueID9,'')) Desc,                          
len(coalesce(RateCon.ValueID10,'')) Desc,                          
len(coalesce(RateCon.ValueID11,'')) Desc,                          
len(coalesce(RateCon.ValueID12,'')) Desc,                          
len(coalesce(RateCon.ValueID13,'')) Desc,                          
len(coalesce(RateCon.ValueID14,'')) Desc,                          
len(coalesce(RateCon.ValueID15,'')) Desc                          

if @Temp_Loading is null
	Select @Temp_Loading=1
	
Select @Loading=@Loading*@Temp_Loading

if @Temp_HoldF is null
	Select @Temp_HoldF=0

if @Temp_HoldF=1 
Begin
	Select @HoldF=@Temp_HoldF
	Select @HoldMessage=@HoldMessage+char(13)+char(10)+@Temp_HoldMessage 
End

if @Temp_CID is null
	Select @Temp_CID=''

if @Temp_CID<>''
Begin
	Select @CID=@CID+'|'+@Temp_CID
End

if @Temp_SRate is null
	Select @Temp_SRate=0

Select @SRate=@SRate+@Temp_SRate 

insert into @RateCon Select @Loading, @HoldF,@HoldMessage,@CID, @P_TSI, @SRate
Return
END  


go


--1.2.3
--25 Agst 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaimInfo_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QClaimInfo_Data
END
GO
CREATE PROCEDURE QClaimInfo_Data(@P_CNO integer)                  
as                  
SELECT         
C1.CNO, C1.ANO, C1.ClaimNo, C1.PolicyNo, C1.CertificateNo, C1.Description, C1.Remarks, C1.Comment,            
C1.UniqueF, C1.LargeF, C1.SurveyF, C1.Reason, C1.Matters, C1.Notes, C1.RecoverableF,
C3.Loss,             
C3.Deductible,            
C3.Salvage,            
C3.Cost,            
C3.Subrogation,            
C3.Claim,             
C3.Reserved,            
C4.ETShare,            
C4.ERetention,  
C2.FLDID1, C2.VALUEID1, C2.VALUEDESC1, 0 as FLDSEARCH1,                    
C2.FLDID2, C2.VALUEID2, C2.VALUEDESC2, 0 as FLDSEARCH2,                    
C2.FLDID3, C2.VALUEID3, C2.VALUEDESC3, 0 as FLDSEARCH3,                    
C2.FLDID4, C2.VALUEID4, C2.VALUEDESC4, 0 as FLDSEARCH4,                    
C2.FLDID5, C2.VALUEID5, C2.VALUEDESC5, 0 as FLDSEARCH5,                    
C2.FLDID6, C2.VALUEID6, C2.VALUEDESC6, 0 as FLDSEARCH6,                    
C2.FLDID7, C2.VALUEID7, C2.VALUEDESC7, 0 as FLDSEARCH7,                    
C2.FLDID8, C2.VALUEID8, C2.VALUEDESC8, 0 as FLDSEARCH8,                    
C2.FLDID9, C2.VALUEID9, C2.VALUEDESC9, 0 as FLDSEARCH9,                    
C2.FLDID10, C2.VALUEID10, C2.VALUEDESC10, 0 as FLDSEARCH10,                    
C2.FLDID11, C2.VALUEID11, C2.VALUEDESC11, 0 as FLDSEARCH11,                    
C2.FLDID12, C2.VALUEID12, C2.VALUEDESC12, 0 as FLDSEARCH12,                    
C2.FLDID13, C2.VALUEID13, C2.VALUEDESC13, 0 as FLDSEARCH13,                    
C2.FLDID14, C2.VALUEID14, C2.VALUEDESC14, 0 as FLDSEARCH14,                    
C2.FLDID15, C2.VALUEID15, C2.VALUEDESC15, 0 as FLDSEARCH15,    
C1.SysUserID           
FROM CLAIM C1             
Left Join CINFO C2 on (C2.CNO=C1.CNO)             
Left Join QClaim_CCalc() C3 on (C3.CNO=C1.CNO)             
Left Join CArrHeader C4 on (C4.CNO=C1.CNO)            
WHERE C1.CNO=@P_CNO
go

--17 Nov 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetIndemnityClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGetIndemnityClaimForCashCall
END
GO
Create Procedure QGetIndemnityClaimForCashCall(@P_CNO as integer)                  
as     
Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+CCalc.RCost)) 
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+pCCalc.RCost),0)) 
as Indemnity 
from CCalc 
Inner Join Claim on (Claim.CNO=CCalc.CNO)
Inner Join TOC on (TOC.TOC=Claim.TOC)
Left Join CCalc pCCalc on (pCCalc.CNO=Claim.pCNO and pCCalc.Currency=CCalc.Currency and Claim.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)
Where CCALC.CNO=@P_CNO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionIndemnityClaimForCashCall') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGetConjunctionIndemnityClaimForCashCall
END
GO
Create Procedure QGetConjunctionIndemnityClaimForCashCall(@P_CNO as integer)
as

Select sum(CCalc.Rate * ((CCalc.Claim - CCalc.Deductible - CCalc.Salvage + CCalc.Cost - CCalc.Subrogation)*CCalc.Share/100+CCalc.RCost)) 
      -sum(coalesce(pCCalc.Rate * ((pCCalc.Claim - pCCalc.Deductible - pCCalc.Salvage + pCCalc.Cost - pCCalc.Subrogation)*pCCalc.Share/100+pCCalc.RCost),0)) 
as Indemnity 
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner join Claim C2 ON (C2.ANO=A2.ANO and C2.CType<>'C' and (C2.CStatus='A' or C2.pCStatus='A'))
Inner Join CCalc on (CCALC.CNO=C2.CNO)
Inner Join TOC on (TOC.TOC=C2.TOC)
Left Join CCalc pCCalc on (pCCalc.CNO=C2.pCNO and pCCalc.Currency=CCalc.Currency and C2.CSeqNo>0 and TOC.CashCallOnPartialPaymentF=1)
Where C1.CNO=@P_CNO 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW06B') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW06B 
END
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE,
pC.CAMOUNT as PREVCAMOUNT, pc.XPAMOUNT as PREVXPAMOUNT, pC.DAmount as PREVDAmount, pC.QAMOUNT as PREVQAMOUNT, pC.SP1AMOUNT as PREVSP1AMOUNT, pC.SP2AMOUNT as PREVSP2AMOUNT, pC.SP3AMOUNT as PREVSP3AMOUNT, pC.AAmount as PREVAAmount, pC.FAmount as PrevFAmount,
pc.XL1AMOUNT as PREVXL1AMOUNT, pc.XL2AMOUNT as PREVXL2AMOUNT, pc.XL3AMOUNT as PREVXL3AMOUNT,pc.XL4AMOUNT as PREVXL4AMOUNT,pc.XL5AMOUNT as PREVXL5AMOUNT,pc.XL6AMOUNT as PREVXL6AMOUNT,pc.XL7AMOUNT as PREVXL7AMOUNT,pC.QXOLAMOUNT as PREVQXOLAMOUNT, pc.RAMOUNT as PREVRAMOUNT,
TOC.CashCallOnPartialPaymentF
FROM CLAIM
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN TOC on (TOC.TOC=CLAIM.TOC)
INNER JOIN CARRHEADER C ON (C.CNO=CLAIM.CNO)
INNER JOIN RARRHEADER R ON (R.ANO=ACCEPTANCE.ANO)
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
LEFT JOIN CARRHEADER pC ON (pC.CNO=CLAIM.pCNO and CLAIM.CSEQNO>0)
WHERE CLAIM.CNO=@P_CNO 
go

--1 Dec 2020
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_Underwriter') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FL_Underwriter
END
GO
CREATE function FL_Underwriter(@P_Branch varchar(10))        
RETURNS Table          
AS RETURN          
(        
 Select SysUser.*
 From sysuser
 Where (SysUser.Role in ('COMMON','UNDERWRITER') Or SysUser.ARole in ('COMMON','UNDERWRITER')) and SysUser.AllowedF=1 
 and (SysUser.Type='SUPERVISOR' or exists (Select S.Branch from SysUserBranch S Where  S.AllowedF=1 and S.ID=SysUser.ID and S.Branch=@P_Branch))    
) 


go

--2 Dec 2020
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='FDTABDET' AND CONSTRAINT_NAME='I_FDTABDET')
Begin
Alter Table FDTABDET drop constraint I_FDTABDET
end
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'FDTABDET'))
begin
ALter Table FDTABDET drop column Currency
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Lower' AND Object_ID = Object_ID(N'FDTABDET'))
begin
Alter Table FDTABDET add Lower Float
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Upper' AND Object_ID = Object_ID(N'FDTABDET'))
begin
Alter Table FDTABDET add Upper Float
end
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_FDTABDET' AND object_id = OBJECT_ID(N'FDTABDET'))
Begin
Create Unique Index I_FDTABDET on FDTABDET(FDID, SEGMENT, LOWER)
end
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoApplyF' AND Object_ID = Object_ID(N'FDTAB'))
begin
ALTER TABLE FDTAB ADD
	AutoApplyF bit NULL

DECLARE @v sql_variant 
SET @v = N'Auto Apply Fee and Duty (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'AutoApplyF'
end
GO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_AutoApplyFeeDuty') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QGet_AutoApplyFeeDuty
END
GO
CREATE Procedure QGet_AutoApplyFeeDuty(@P_ANO as integer)
AS
Select Top 1 F.FDID, F.FDType, F.DESCRIPTION as REMARK, F.Currency, Fd.Amount
from Acceptance A
Inner Join Premium_Calculation(@P_ANO) P on (P.ANO=A.ANO)
Inner join Cover C on (C.CNO=A.CNO and C.ISType in ('I','L'))
Inner join FDTAB F on ((F.Atype='ALL' or F.Atype = A.AType) and F.AutoApplyF=1 and F.Currency=P.Currency and F.FDType in ('F','D'))
Inner Join FDTABDET Fd on (Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=C.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0)
Where A.ANO=@P_ANO



go

--4 Dec 2020 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MasterF' AND Object_ID = Object_ID(N'SysBatchBE'))
begin
Alter Table SysBatchBE Add MasterF Bit
end
go

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXCGROUP' AND Object_ID = Object_ID(N'BizMap'))
begin
ALTER TABLE BizMap ADD
	EXCGROUP varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Exclusion Company Group'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BizMap', N'COLUMN', N'EXCGROUP'
end
GO

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_BizMap') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_BizMap
END
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(20) 
Declare @EType varchar(20) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @BizmapID varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
	 if @P_Source='' 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup, 
	  @BizmapID=A.BizmapID
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=A.Source)
	  Where A.ANO=@P_ANO 
	 End 
	 Else 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=@P_Source)
	  Where A.ANO=@P_ANO 
	 End 
End 
ELSE 
BEGIN 
	SELECT 
		@CType=Source.CType, 
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
		@EType=Case When Source.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
		@Source_LOB=Source.LOB, 
		@Segment='DIRECT', 
	    @ISType='I' 
	from Profile Source 
	Where Source.ID=@P_Source	 
END 
 
Select Top 1 @ID=B.ID 
from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (EType='<ANY>' or EType=@EType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (EXCgroup='<ANY>' or EXCgroup<>@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=SegmentGroup) 
Order By OrderNo, ID 

return(coalesce(@ID,@BizMapID)) 
End 




go
--2020 v.1.24
--8 Dec 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QUndo_Claim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QUndo_Claim_To_Adm
END
GO
CREATE Procedure QUndo_Claim_To_Adm(@P_CNO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='E' then A1.Amount else 0 end) as Amount_7,                      
sum(Case When A1.Code='S' then A1.Amount else 0 end) as Amount_8,                      
sum(Case When A1.Code='L' then A1.Amount else 0 end) as Amount_9,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code='F' then A1.Amount else 0 end) as Amount_15,                      
sum(Case When A1.Code='D' then A1.Amount else 0 end) as Amount_16,                      
sum(Case When A1.Code='I' then A1.Amount else 0 end) as Amount_17,
Max(A2.Amount_18) as Amount_18		-- Tax Adjustment from Progresif taax
from ClaAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.CNO=@P_CNO
Group By A1.AdmNo    

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW07L') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW07L
END
GO
CREATE PROCEDURE CLVIEW07L(@P_CNO AS INTEGER)  
AS  
SELECT cast(0 as Bit) as ProcessFlag, ClaAss.AdmNo, ClaAss.RefNo, ClaAss.BillDate, ClaAss.ClaimNo, ClaAss.ID, Profile.Name, ClaAss.Type, ClaAss.Currency as Currency_OC,  
'CLAIM'=sum(  
CASE  
        WHEN CLAASS.CODE='A' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DEDUCTIBLE'=sum(  
CASE  
        WHEN CLAASS.CODE='E' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'COST'=sum(  
CASE  
        WHEN CLAASS.CODE='L' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SALVAGE'=sum(  
CASE  
        WHEN CLAASS.CODE='S' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SUBROGATION'=sum(  
CASE  
        WHEN CLAASS.CODE='R' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'ADJUSTMENT'=sum(  
CASE  
        WHEN CLAASS.CODE='I' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'PREMIUM'=sum(  
CASE  
        WHEN CLAASS.CODE='P' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'VAT'=sum(  
CASE  
        WHEN CLAASS.CODE='V' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'TAX'=sum(  
CASE  
        WHEN CLAASS.CODE='T' THEN ClaAss.AMOUNT  
        ELSE 0  
END)
+
Max(coalesce(Admlink.Amount_18,0)),  
'FEE'=sum(  
CASE  
        WHEN CLAASS.CODE='F' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DUTY'=sum(  
CASE  
        WHEN CLAASS.CODE='D' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
ClaAss.Posted AS Posted  
FROM ClaAss 
Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE ClaAss.CNO=@P_CNO  
GROUP BY ClaAss.AdmNo, ClaAss.RefNo, ClaAss.BillDate, ClaAss.ClaimNo, ClaAss.ID, Profile.Name, ClaAss.Type, ClaAss.Currency, ClaAss.Posted        
go

--10 Dec 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_No' AND Object_ID = Object_ID(N'SysUser'))
begin
ALTER TABLE SysUser ADD
 ID_No varchar(30) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Type' AND Object_ID = Object_ID(N'SysUser'))
begin
ALTER TABLE SysUser ADD
  ID_Type varchar(10) NULL
end
GO



--11 Dec 2020
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ICPSF' AND Object_ID = Object_ID(N'NOC'))
begin
ALTER TABLE NOC ADD
	ICPSF bit NULL
end
go


--17 Dec 2020 : Penambahan Payment Reference Type di Profile Account
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefType' AND Object_ID = Object_ID(N'ProAcc'))
begin
ALTER TABLE ProAcc ADD
	RefType varchar(50) NULL

DECLARE @v sql_variant 
SET @v = N'Payment Reference Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ProAcc', N'COLUMN', N'RefType'
end
GO



--21 Dec 2020
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCLAIMEQUALTODECLARED')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCLAIMEQUALTODECLARED','Allow Claim Equal To Declared Value','ACTIVITIES',0
end
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCHECKDECLAREDVALUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCHECKDECLAREDVALUE 
END
GO
CREATE PROCEDURE QCHECKDECLAREDVALUE (@PCNO AS INTEGER)   
AS
Select *
from
(
Select 
	coalesce(ICoverNOC.NOC,'') as NOC,
	SUM(CLLOSS.Estimate/CLLOSS.Rate) as Estimate, 
	SUM(CLLOSS.Amount/CLLOSS.Rate) as Amount, 
	MAX(Case When ICOVER.AMOUNT<>0 and ICOVER.AMOUNT_AOE<>0 THEN CLLOSS.DECLARED*ICOVER.AMOUNT_AOE/ICOVER.AMOUNT ELSE CLLOSS.DECLARED END) as DECLARED,
	MAX(ICOVER.AMOUNT) as LOL
	from CLLOSS 
	INNER JOIN CLAIM ON (CLAIM.CNO=CLLOSS.CNO)
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
	INNER JOIN NOCTAB ON (NOCTAB.NOC=CLLOSS.NOC) 
	INNER JOIN ICOVER ON (ICOVER.INO=CLLOSS.INO)
	LEFT JOIN ICOVERNOC ON ((ICoverNOC.PCT<>0 or ICoverNOC.Amount<>0) And ICOVERNOC.INO=CLLOSS.INO and ICOVERNOC.NOC=CLLOSS.NOC
	AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<CLAIM.LossDate or (ICOVERNOC.SDATE=CLAIM.LossDate AND ACCEPTANCE.STIME<=CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                     
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>CLAIM.LossDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=CLAIM.LossDate AND ACCEPTANCE.ETIME>CLAIM.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                              
) 
Where CLLOSS.Declared>1 and CLLoss.CNO=@PCNO and (NOCTAB.SubLimitF=0 or coalesce(ICoverNOC.NOC,'')<>'') 
Group by CLLOSS.CNO, CLLOSS.INO, coalesce(ICoverNOC.NOC,'') 
) C
Where Estimate>=Declared or Amount>=declared or Estimate>LOL or Amount>LOL

go

--2020 v.1.2.4
--16 Nov 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCertificate_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCertificate_Data
END
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
C.COVERNO, C.SEGMENT, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.PPeriod,
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersID, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,     
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.BID,
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
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qPolicy_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure qPolicy_Data
END
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
A1.NCDate,          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersID, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.BID,
Interest.Currency, Interest.TSI, Interest.ATSI,          
ICoverPol.CURRENCY as Currency_POL, ICoverPol.Amount as Amount_POL,
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
Left Join ICoverPOL on (ICoverPOL.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 
go

-- Script 2020 v.1.2.10
--19 Jan 2021

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NetAdjustmentDepositF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab ADD
	NetAdjustmentDepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Net Amount for Adjustment Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'NetAdjustmentDepositF'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyCommissionDepositF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab add
	ApplyCommissionDepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Commission Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'ApplyCommissionDepositF'
end
GO




GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEPOSIT_REINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN

DROP Procedure QDEPOSIT_REINSURANCE_CESSION
END
GO
CREATE Procedure QDEPOSIT_REINSURANCE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO
And Acceptance.SDate Between Reinsurance.SDate And Reinsurance.EDate       
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  


go


--2020 v1.2.11
--28 Jan 2021
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

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CheckShortFallF' AND Object_ID = Object_ID(N'ACCDEPOSIT'))
BEGIN
ALTER TABLE ACCDEPOSIT ADD
	CheckShortFallF bit NULL
DECLARE @v sql_variant 
SET @v = N'Check Deposit Short Fall (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCDEPOSIT', N'COLUMN', N'CheckShortFallF'
end
GO


COMMIT

--29 Jan 2021

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCINVOICE') AND type in (N'U'))
BEGIN
CREATE TABLE ACCINVOICE
	(
	ANO int NOT NULL,
	InvoiceNo varchar(50) NULL,
	InvoiceDate smalldatetime NULL,
	InvoiceNominal float(53) NULL,
	InvoiceRemarks varchar(255) NULL
	)  ON [PRIMARY]
DECLARE @x sql_variant 
SET @x = N'Original Acceptance ANO'
EXECUTE sp_addextendedproperty N'MS_Description', @x, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'ANO'

DECLARE @y sql_variant 
SET @y = N'Invoice No'
EXECUTE sp_addextendedproperty N'MS_Description', @y, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'InvoiceNo'

DECLARE @z sql_variant 
SET @z = N'Invoice Payment Date'
EXECUTE sp_addextendedproperty N'MS_Description', @z, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'InvoiceDate'

DECLARE @a sql_variant 
SET @a = N'Payment Nominal'
EXECUTE sp_addextendedproperty N'MS_Description', @a, N'SCHEMA', N'dbo', N'TABLE', N'ACCINVOICE', N'COLUMN', N'InvoiceNominal'

ALTER TABLE ACCINVOICE ADD CONSTRAINT
	I_ACCINVOICE PRIMARY KEY CLUSTERED 
	(
	ANO
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

end
GO



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Acceptance_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Drop_Acceptance_Link
END
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   
Delete from PNOTES Where ANO=@P_ANO   
Delete from ICOVERPOL Where ANO=@P_ANO   
Delete from ClaimPaymentSchedule Where ANO=@P_ANO   
Delete from AccInvoice Where ANO=@P_ANO   

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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CheckInvoiceF' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE AINFODET ADD
	CheckInvoiceF bit NULL
DECLARE @v sql_variant 
SET @v = N'Check for Payment Invoice (Trade Insurance) (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'CheckInvoiceF'
end
GO

COMMIT
go


--7 Jan 2021

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SignerImageID' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE SysUser ADD
	SignerImageID int NULL
DECLARE @v sql_variant 
SET @v = N'Signer Signature'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'SignerImageID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SignerName' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE SysUser ADD
	SignerName varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Signer Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'SignerName'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SignerTitle' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE SysUser ADD
	SignerTitle varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Signer Title'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'SignerTitle'
end
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CASHFLOWF' AND Object_ID = Object_ID(N'MParam'))
BEGIN
ALTER TABLE MParam ADD
	CASHFLOWF bit NULL
DECLARE @v sql_variant 
SET @v = N'Memorial Use for Cash Flow (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MParam', N'COLUMN', N'CASHFLOWF'
end
GO


COMMIT
go

--22 Jan 2021
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Get_AccClass_Value') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Get_AccClass_Value
END
GO
Create FUNCTION fn_Get_AccClass_Value(@AccClass varchar(10), @Branch as varchar(10), @SDate as smalldatetime, @EDate as smalldatetime, @Account varchar(10), @Currency varchar(10))
RETURNS Float
AS
BEGIN
	Declare @SBranch as varchar(1024)
	Declare @EachF as bit
	Declare @DebitF as bit
	Declare @CounterF as bit
	Declare @AcGroup as varchar(50)
	Declare @Nominal as float
	Declare @NominalAdd as Float

	Select @Nominal=0
	Select @NominalAdd=0

	Select @SBranch=dbo.Get_Sub_Branch(@Branch)

	Select @EachF=EachF, @DebitF=DebitF, @CounterF=CounterF, @AcGroup=AcGroup from AccClass Where AccClass=@AccClass

	Declare @Temp_Branch Table (Branch varchar(10), End_Date Smalldatetime)
	insert into @Temp_Branch
	Select Branch.Branch, Branch.End_Date
	from Branch Where Branch.Op_Flag=1 and CHARINDEX(Branch.Branch, @SBranch)<>0

	IF @CounterF=1
	Begin
		Select @Nominal=
		sum(
		case 
		when @Currency='' then
			case 
			when @EachF=0 then Journal.Credit-Journal.Debit 
			when @DebitF=1 then Journal.Credit
			else -Journal.Debit
			end
		else
			case 
			when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
			when @DebitF=1 then Journal.Credit_OC
			else -Journal.Debit_OC
			end
		end
		)
		from @Temp_Branch Branch
		Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date and Source.SL_Cat not in ('M'))
		Inner join Journal_Account Journal on (Journal.Source=Source.Source)
		Inner Join RAccClassDet on (RAccClassDet.AccClass=@AccClass and RAccClassDet.Account=Journal.Account)
		Where Source.Date Between @SDate and @EDate
		and (@Account='' or Journal.Account=@Account)
		and (@Currency='' or Journal.Currency=@Currency)
		and Exists (
			Select Top 1 Journal.Source
			from Journal_Account Journal
			Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
			Where Journal.Source=Source.Source
			) 
		and not Exists (
			Select Top 1 AccClassDet.Account 
			from AccClassDet 
			Where AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account
			)

		if @AcGroup='CASHFLOW'
		Begin
			Select @NominalAdd=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Credit-Journal.Debit 
				when @DebitF=1 then Journal.Credit
				else -Journal.Debit
				end
			else
				case 
				when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
				when @DebitF=1 then Journal.Credit_OC
				else -Journal.Debit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join mVoucher Voucher on (Voucher.Branch=Branch.Branch and Voucher.Date<=Branch.End_Date and Voucher.SL_Cat in ('M'))
			Inner join mJournal Journal on (Journal.Voucher=Voucher.Voucher)
			Inner Join RAccClassDet on (RAccClassDet.AccClass=@AccClass and RAccClassDet.Account=Journal.Account)
			Inner Join Acclink on (Acclink.Voucher=Voucher.Voucher)
			Inner join Mparam on (MParam.Type=Acclink.Type and MParam.CASHFLOWF=1)
			Where Voucher.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and Exists (
				Select Top 1 Journal.Voucher 
				from Journal Journal
				Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
				Where Journal.Voucher=Voucher.Voucher
				) 
			and not Exists (
				Select Top 1 AccClassDet.Account 
				from AccClassDet 
				Where AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account
				)
		end
	End
	Else
	Begin
		Select @Nominal=
		sum(
		case 
		when @Currency='' then
			case 
			when @EachF=0 then Journal.Debit -Journal.Credit
			when @DebitF=1 then Journal.Debit
			else -Journal.Credit
			end
		else
			case 
			when @EachF=0 then Journal.Debit_OC-Journal.Credit_OC
			when @DebitF=1 then Journal.Debit_OC
			else -Journal.Credit_OC
			end
		end
		)
		from @Temp_Branch Branch
		Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date and Source.SL_Cat not in ('M'))
		Inner join Journal_Account Journal on (Journal.Source=Source.Source)
		Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
		Where Source.Date Between @SDate and @EDate
		and (@Account='' or Journal.Account=@Account)
		and (@Currency='' or Journal.Currency=@Currency)
	End

	if @Nominal is Null
		Select @Nominal=0

	if @NominalAdd is Null
		Select @NominalAdd=0

	return (@Nominal+@NominalAdd)
END

go

--2 Feb 2021
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RecoverableF' AND Object_ID = Object_ID(N'COLTAB'))
BEGIN
ALTER TABLE COLTAB ADD
	RecoverableF bit NULL
DECLARE @v sql_variant 
SET @v = N'Claim is Recoverable (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLTAB', N'COLUMN', N'RecoverableF'
end
GO


COMMIT
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_ClaimSubrogation_Monitoring') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function Get_ClaimSubrogation_Monitoring
END
GO
Create function Get_ClaimSubrogation_Monitoring(@DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, 
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, C4.RegDate, C1.ADate, C2.Remark as Interest, C2.Estimate, C2.Amount as Indemnity, C2.Payment as ID, Profile.Name, S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Inner Join CLLOSS C2 on (C2.CNO=C1.CNO)
	Inner Join Profile on (Profile.ID=C2.Payment)
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C1.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Where C1.RecoverableF=1
	and C1.CType<>'C' and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  


go

--10 Dec 2021
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_No' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE SysUser ADD
	ID_No varchar(30) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID_Type' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE SysUser ADD
	ID_Type varchar(10) NULL
end
go
COMMIT
--2 Feb 2021
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_ClaimSubrogation_Monitoring') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function Get_ClaimSubrogation_Monitoring
END
GO
Create function Get_ClaimSubrogation_Monitoring(@DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, 
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, C4.RegDate, C1.ADate, C2.Remark as Interest, C2.Estimate, C2.Amount as Indemnity, C2.Payment as ID, Profile.Name, S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Inner Join CLLOSS C2 on (C2.CNO=C1.CNO)
	Inner Join Profile on (Profile.ID=C2.Payment)
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C1.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Where 
	C1.CType<>'C' and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  

go
--Update 13 Jan 2021
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DExtDataF' AND Object_ID = Object_ID(N'ComAcc'))
BEGIN
ALTER TABLE ComAcc ADD
	DExtDataF bit NULL
DECLARE @v sql_variant 
SET @v = N'Download for Extdata Data Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc', N'COLUMN', N'DExtDataF'
end
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SubRefType' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
ALTER TABLE pVoucher ADD
	SubRefType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Payment Sub Reference Type ('''',''RTGS'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'SubRefType'
end
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SubRefType' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE Request ADD
	SubRefType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Payment Sub Reference Type ('''',''RTGS'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'SubRefType'
end
GO


COMMIT
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEDEXTDATA')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGEDEXTDATA','Allow Change Downloaded External Data', 'ACTIVITIES',0
end
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserComAcc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_UserComAcc
END
go
CREATE FUNCTION FN_UserComAcc (@P_UserID as varchar(50), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT ComAcc.*       
 from ComAcc       
 Left Join Branch on (Branch.Branch=@P_Branch)      
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' or Exists (Select Top 1 SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.AllowedF=1 and SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and          
(@P_Branch='' or        
(Coalesce(Branch.Op_Flag,0)=0) or      
(ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch)) or           
(ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch)))          
) 



go
-- Cumulative V.1.2.12
--4 FEB 2021
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MaxNumDuplReg' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	MaxNumDuplReg int NULL
DECLARE @v sql_variant 
SET @v = N'Maximum Number of Duplicate Register (0 : Not Allow Duplicate, 1...n : Number of Duplicate Allowed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'MaxNumDuplReg'
end
GO

COMMIT

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectInsured_Upload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCheckObjectInsured_Upload
END
GO
CREATE Procedure QCheckObjectInsured_Upload(@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0, @PTOC as varchar(10)='', @M_RegNo as varchar(50)='') 
as 

Declare @UniqueRefNoF as Bit
Declare @MaxNumDuplReg as int

Declare @TOC Table(TOC varchar(10), UniqueRefNoF bit, MaxNumDuplReg int)

insert into @TOC
Select TOC.TOC, TOC.UniqueRefNoF, TOC.MaxNumDuplReg from TOC
Where ((@PTOC<>'' and TOC.TOC=@PTOC) or (@PTOC='' and TOC.RegID=@RegID))

Select Top 1 @UniqueRefNoF=UniqueRefNoF, @MaxNumDuplReg=MaxNumDuplReg from @TOC

if @UniqueRefNoF=0
	Select 
	C1.CoverNo as [Quotation No], 
	A1.RegNo as [CI No], 
	A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
	C1.Insured, 
	A1.SDate as Inception, 
	A1.EDate as Expiry, 
	A1.ANO, 
	A1.RefNo, 
	@UniqueRefNoF as UniqueRefNoF
	from
	(
		Select min(A1.ANO) as ANO
		from Acceptance A1
		Inner Join Cover C1 on (C1.CNO=A1.CNO)
		Inner Join @TOC TOC on (TOC.TOC=A1.TOC)
		Where A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID and (@M_RegNo='' or A1.RegNo=@M_RegNo)
		and A1.AType not in ('A','C') 
		and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
		and A1.PDate<A1.PPDate 
		and ( 
			(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
			(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
			) 
		having count(A1.ANO)>=@MaxNumDuplReg+1
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Inner Join Cover C1 on (C1.CNO=A1.CNO)
else
	Select 
	C1.CoverNo as [Quotation No], 
	A1.RegNo as [CI No], 
	A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
	C1.Insured, 
	A1.SDate as Inception, 
	A1.EDate as Expiry, 
	A1.ANO, 
	A1.RefNo,
	@UniqueRefNoF as UniqueRefNoF 
	from
	(
		Select min(A1.ANO) as ANO
		from Acceptance A1
		Inner Join Cover C1 on (C1.CNO=A1.CNO)
		Inner Join @TOC TOC on (TOC.TOC=A1.TOC)
		Where A1.RefNo=@RefNo and (@M_RegNo='' or A1.RegNo=@M_RegNo)
		and A1.AType not in ('A','C') 
		and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
		and A1.PDate<A1.PPDate 
		and ( 
			(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
			(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
			) 
		having count(A1.ANO)>=@MaxNumDuplReg+1
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Inner Join Cover C1 on (C1.CNO=A1.CNO)
GO
--2 FEB 2021
Drop function Get_ClaimSubrogation_Monitoring
GO
Create function Get_ClaimSubrogation_Monitoring(@DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, 
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, C4.RegDate, C1.ADate, C2.Remark as Interest, C2.Estimate, C2.Amount as Indemnity, C2.Payment as ID, Profile.Name, S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Inner Join CLLOSS C2 on (C2.CNO=C1.CNO)
	Inner Join Profile on (Profile.ID=C2.Payment)
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C1.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Where 
	C1.CType<>'C' and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  

GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'accinvoice'))
begin	
ALTER TABLE accinvoice ADD
Last_Opr varchar(50) NULL
end
go	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'accinvoice'))
begin	
ALTER TABLE accinvoice ADD
Last_Update smalldatetime NULL
end
go	 


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'accdeposit'))
begin	
ALTER TABLE accdeposit ADD
Last_Opr varchar(50) NULL
end
go	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'accdeposit'))
begin	
ALTER TABLE accdeposit ADD
Last_Update smalldatetime NULL
end
go	 
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICOVERNOC' AND CONSTRAINT_NAME='I_ICOVERNOC')
Begin
ALTER TABLE [dbo].[ICOVERNOC] DROP CONSTRAINT [I_ICOVERNOC]
END
GO

ALTER TABLE [dbo].[ICOVERNOC] ADD  CONSTRAINT [I_ICOVERNOC] PRIMARY KEY NONCLUSTERED 
(
	[INO] ASC,
	[NOC] ASC,
	[ORDERNO] ASC,
	[PolicyYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'gpid' AND Object_ID = Object_ID(N'rpbucket'))
begin	
alter table rpbucket add gpid int
end
go



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NetAdjustmentDepositF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	NetAdjustmentDepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Net Amount for Adjustment Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'NetAdjustmentDepositF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyCommissionDepositF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	ApplyCommissionDepositF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Commission Deposit (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'ApplyCommissionDepositF'
END
GO
--Default 1 for NetAdjustmentDepositF
Update SysTab Set NetAdjustmentDepositF=1 where NetAdjustmentDepositF is null
Update SysTab Set ApplyCommissionDepositF=1 where ApplyCommissionDepositF is null
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEPOSIT_REINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QDEPOSIT_REINSURANCE_CESSION
END
GO
CREATE Procedure QDEPOSIT_REINSURANCE_CESSION (@P_ANO integer, @P_RType varchar(255))     
AS                           
SELECT Top 1 Reinsurance.RID, Reinsurance.SHARE
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Reinsurance on (Reinsurance.RType='Q')      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=ACCEPTANCE.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE ACCEPTANCE.ANO=@P_ANO
And Acceptance.SDate Between Reinsurance.SDate And Reinsurance.EDate       
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPOLICY_DEPOSIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QPOLICY_DEPOSIT
END
GO
CREATE Procedure QPOLICY_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.Currency,
sum(AccAss.Amount) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('DI','IC','PD')
Group by AccAss.Currency

GO


--3 MAR 2021 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	Status varchar(1) NULL
	DECLARE @v sql_variant 
SET @v = N'''P''ending, ''C''losed/Rejected; ''A''ccepted'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'Status'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ErrMsg' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	ErrMsg varchar(255) NULL
	DECLARE @v sql_variant 
SET @v = N'Error Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'ErrMsg'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LDATE' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LDATE smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LDATE'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LTIME' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LTIME varchar(8) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LTIME'
END
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LUSERID' AND Object_ID = Object_ID(N'SysLogDownload'))
BEGIN
ALTER TABLE SysLogDownload ADD
	LUSERID varchar(50) NULL
	DECLARE @v sql_variant 
SET @v = N'Last Update User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysLogDownload', N'COLUMN', N'LUSERID'
END
GO


--27 Mei 2021
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'PTYPE'))
BEGIN 
ALTER TABLE PTYPE ADD
	Last_Update Smalldatetime 
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'PTYPE'))
BEGIN
ALTER TABLE PTYPE ADD
	Last_Opr Varchar (10) 
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Prefix' AND Object_ID = Object_ID(N'PTYPE'))
BEGIN
ALTER TABLE PTYPE ADD
	Prefix Varchar (10) 
end
go


GO

--VERSIONING
alter table versioning alter column vernoapp varchar(50)
go
alter table versioning alter column vernows varchar(50)
go
alter table versioning alter column vernoproclib varchar(50)
go
insert into versioning
select '2020 V.1.2.14',GETDATE(),'2020 V.1.2.14',GETDATE(),'K: 2020 V.1.2.14',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.19 Update Script - ACCASS (DEFAULT)'
Select @CurrSCript='57 Script Komulatif Konsol 2020 V.1.2'


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


