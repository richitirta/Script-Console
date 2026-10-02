
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vProfile') ) 
BEGIN 
DROP VIEW dbo.vProfile 
 END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CRM_NO' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CRM_NO varchar(50)
end
DECLARE @v sql_variant 
SET @v = N'CRM NO'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CRM_NO'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestF bit
end
DECLARE @v sql_variant 
SET @v = N'Request Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestF'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestMessage' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestMessage	varchar(max)
end
DECLARE @v sql_variant 
SET @v = N'RequestMessage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestMessage'
GO
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestName' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	RequestName	varchar
end
DECLARE @v sql_variant 
SET @v = N'RequestName'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'RequestName'
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CTime' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	CTime	varchar(8)
end
DECLARE @v sql_variant 
SET @v = N'Creation Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'CTime'
GO

Create View vProfile
WITH SCHEMABINDING
AS
select 
	Profile.ID
	,Profile.Salutation
	,Profile.FirstName
	,Profile.MidName
	,Profile.LastName
	,Profile.Name
	,Profile.Initial
	,Profile.Address_1
	,Profile.Address_2
	,Profile.Address_3
	,Profile.City
	,Profile.ZipCode
	,Profile.Phone_1
	,Profile.Phone_2
	,Profile.Mobile_1
	,Profile.Mobile_2
	,Profile.Fax_1
	,Profile.Fax_2
	,Profile.Contact
	,Profile.ContactAddress
	,Profile.ContactPhone
	,Profile.Title
	,Profile.PTYPE
	,Profile.RefID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.TaxID) as TaxID
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email) as Email
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email_2) as Email_2
	,Profile.TaxName
	,Profile.TaxAddress
	,Profile.VatF
	,Profile.TaxF
	,Profile.LOB
	,Profile.Country
	,Profile.CorporateF
	,Profile.IntermediaryF
	,Profile.Rating
	,Profile.Rating_Agency
	,Profile.Rating_Date
	,Profile.CGroup
	,Profile.SCGroup
	,Profile.Area
	,Profile.TaxType
	,Profile.VAT
	,Profile.TAX
	,Profile.TAXPCT
	,Profile.NTAXINCOME
	,Profile.LAST_OPR
	,Profile.LAST_UPDATE
	,Profile.PID
	,Profile.COMM
	,Profile.Disc
	,Profile.RESTRICTEDF
	,Profile.PREFERREDF
	,Profile.REMARK
	,Profile.CTYPE
	,Profile.ProviderF
	,Profile.RedFlag
	,Profile.RedFlagDate
	,Profile.RedFlagTime
	,Profile.RedFlagDescription
	,Profile.RedFlagUser
	,Profile.DumpF
	,dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.USERID) as USERID
	,Profile.CDATE
	,Profile.ASource
	,Profile.Owner
	,Profile.WPC
	,Profile.Grace
	,Profile.Branch
	,Profile.NetCommF
	,Profile.MaxOutGo
	,Profile.LicenseNo
	,Profile.TPAF
	,Profile.Province
	,Profile.XProfileID
	,Profile.ICPSF
	,Profile.RType
	,Profile.LicenseDate
	,Profile.LicenseExpiry
	,Profile.ContactTitle
	,Profile.TAXHSDate
	,Profile.TAXHEDate
	,Profile.MOID
	,Profile.HSCode
	,Profile.BIType
	,Profile.AccruedTax
	,Profile.Last_Time
	,Profile.Regency
	,Profile.SubsidiaryF
	,Profile.Latitude
	,Profile.Longtitude
	,Profile.District
	,Profile.SubDistrict
	,Profile.RoomNo
	,Profile.FloorNo
	,Profile.HomeNo
	,Profile.MOO
	,Profile.SOI
	,Profile.Village
	,Profile.Building
	,Profile.Road
	,Profile.SyncDate
	,Profile.SyncTime
	,Profile.SYNCERRORMESSAGE
	,Profile.BVATF
	,Profile.TVATF
	,Profile.RestrictedDate
	,Profile.RestrictedTime
	,Profile.RestrictedUser
	,Profile.PrivilegeType
	,Profile.DeferralF
	,Profile.VerifiedBy
	,Profile.VerifiedDate
	,Profile.VerifiedTime
	,Profile.VATOLD
	,Profile.VATSubsidiesF
	,Profile.VATESDate
	,Profile.VATEEDate
	,Profile.CBRAID
	,Profile.CBRADATE
	,Profile.CBRANRDATE
	,Profile.ConsentOnDataKeepByCompanyF
	,Profile.ConsentOnDataPrivacyToThirdPartyF
	,Profile.ConsentOnProductAndServiceOfferingF
	,Profile.VerifiedF
	,Profile.AccruedVAT
	,Profile.TAXIDOLD
	,Profile.Email_3
	,Profile.VATCOMMEXEMPTIF
	,Profile.TAXSubsidiesF
	,Profile.CRM_NO
	,Profile.CTime
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO

DROP Procedure GetListActionLog
GO
CREATE Procedure GetListActionLog(@Param2 varchar(10), @Param3 Int, @Param4 int, @Param6 varchar(50))
as 
	if @Param2 in ('UND', 'UND-MW', 'IT', 'MAR')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Cover C3, Acceptance A3, Cover C4, Acceptance A4, Acceptance A5, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and ((A4.LANO=-1 and A3.LANO=-1) or (A4.LANO=A4.ANO and A3.LANO=A3.ANO) or (A4.LANO<>-1 and A3.LANO<>-1 and A3.CertificateNo=A4.CertificateNo)) and A3.CNO=C3.CNO and C3.CNO=C4.PCNO and C4.CNO=A4.CNO and A4.OANO=A5.OANO and A5.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Cover C3, Acceptance A3, Cover C4, Acceptance A4, Acceptance A5, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and ((A4.LANO=-1 and A3.LANO=-1) or (A4.LANO=A4.ANO and A3.LANO=A3.ANO) or (A4.LANO<>-1 and A3.LANO<>-1 and A3.CertificateNo=A4.CertificateNo)) and A3.CNO=C3.CNO and C3.PCNO=C4.CNO and C4.CNO=A4.CNO and A4.OANO=A5.OANO and A5.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Acceptance A3, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and A3.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Service S1, Service S2, Acceptance A2, Acceptance A3, SysUser U1
		Where S.Param2 in ('SVC') and S.Param3=S1.SNO and S1.OSNO=S2.OSNO and S2.ANO=A2.ANO and A2.OANO=A3.OANO and A3.ANO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('SVC')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Service S1, Service S2, SysUser U1
		Where S.Param2=@Param2 and S.Param3=S1.SNO and S1.OSNO=S2.OSNO and S2.SNO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CLM', 'CLM-MW')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Claim C1, Claim C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CSCLM')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), CSClaim C1, CSClaim C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('FA')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('RQ')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('UND-OBJ')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('CLM-EXP')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('POLH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Policy P1, Policy P2, SysUser U1
		Where S.Param2=@Param2 and S.Param3=P1.PNO and P1.OPNO=P2.OPNO and P2.PNO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CLMH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), ClaimH C1, ClaimH C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CLMH')
        Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
        from SysRequest S 
         Left Join SysUser SU on (SU.ID=S.Param5) 
          Left Join SysUserType ST on (ST.Type=S.Param5) 
        Left Join ActionLog A1 on (A1.PID=S.ID), Quotation Q1, Quotation Q2, SysUser U1
            Where S.Param2 = @Param2 and S.Param3=Q1.QNO and Q1.OQNO=Q2.OQNO and Q2.QNO=@Param3
              and U1.ID=S.UserID
             Order By S.ID Desc
	else if @Param2 in ('GLH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Pre_Claim_H C1, Pre_Claim_H C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.PreRegID and C1.GuaranteeNo=C2.GuaranteeNo and C2.PreRegID=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc		
else --if @Param2 in ('PRF')
	Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' 
Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Profile P1, SysUser U1
		Where S.Param2=@Param2 and S.Param6=P1.ID and P1.ID=@Param6
		and U1.ID=S.UserID
		Order By S.ID Desc
GO

Drop function [dbo].[Fn_GetSentToUserProfile]
go
Create function [dbo].[Fn_GetSentToUserProfile](@P_UserType as varchar(20),@P_ActionCode as varchar(10))  
RETURNS Table    
AS RETURN   
( 
Select S.ID, S.Name, S.Type from 
(
Select S1.ID, S1.Name, 'U' as Type from SysUser S1 Where cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S1.Expiry and S1.LockedF=0 and S1.AllowedF=1 
union all 
Select Type as ID, Description as Name, 'T' as Type from SysUserType
) S 
Left Join ActionUser A on (A.ActionUser=S.ID and A.ActionCode=@P_ActionCode), SysUserType S1
Where S1.Type=@P_UserType and (S1.ApplyActionCodeF=0 or (coalesce(A.ActionCode,'')<>'')) and coalesce(A.ActionCode,'')=@P_ActionCode
  )
GO



insert into PatchVersioning
select '1471 Update Script Patch Profile CRM Nov 2025 (REVISI).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1471 Update Script Patch Profile CRM Nov 2025 (REVISI).sql'


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

GO 

