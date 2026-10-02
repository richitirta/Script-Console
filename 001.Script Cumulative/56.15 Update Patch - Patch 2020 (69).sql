
insert into PatchVersioning
select '56.15 Update Patch - Patch 2020 (69)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.14 Update Patch - Patch 2020 (68)'
Select @CurrSCript='56.15 Update Patch - Patch 2020 (69)'


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
			DROP Function fn_GetPolicyActionUser
			DROP Function fn_GetClaimProcessActionUser
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Acceptance A 
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'In', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Production(@ANO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'In', C.Branch, C.ApprLimitPCT)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser and (A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO


GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Claim 
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Estimate or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser and (A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   
GO

DROP Function fn_GetClaimApprovalActionUser
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Claim 
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser and (A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 


