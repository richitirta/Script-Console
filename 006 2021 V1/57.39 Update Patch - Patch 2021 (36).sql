IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPolicyActionUser]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_GetPolicyActionUser 
end
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @ApprLimitPCT=fc.ApprLimitPCT
 from Acceptance A 
 Inner Join fn_Approval_Production(@ANO) fC on (1=1)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetClaimProcessActionUser]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_GetClaimProcessActionUser 
end
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Estimate
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetClaimApprovalActionUser]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_GetClaimApprovalActionUser 
end
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetClaimApprovalActionUser]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_GetClaimApprovalActionUser 
end
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetServicingActionUser]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION fn_GetServicingActionUser 
end
GO
CREATE Function fn_GetServicingActionUser(@ActionCode varchar(10), @SNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When S.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=S.TOC,
 @Branch=S.Branch,
 @ISType=S.ISType,
 @Amount=S.TSI,
 @ApprLimitPCT=100
 from Service S
 Left Join PolicyType PT on (PT.PolicyType=S.PolicyType)
 Left Join Profile BS on (BS.ID=S.BSID) 
 Where S.SNO=@SNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.ID=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from ActionUser S1
			Inner Join SysUser S2 on (S2.Type=S1.ActionUser and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0)
			Inner Join SysUserTOC S3 on (S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime))
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where  S1.ActionCode=@ActionCode and coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO

