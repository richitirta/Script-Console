IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetRequestActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetRequestActionUser
end
GO
CREATE Function fn_GetRequestActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = Case When R.DebtorF=1 Then 'ALLOWRECEIPTREQUEST' Else 'ALLOWPAYMENTREQUEST' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 


 Select @Condition=coalesce(nA.Condition,0)
 from ActionList AL
 Outer Apply (
	Select Top 1 S.ActionCode from SysRequest S Where S.Param2='RQ' and S.Param6=@Request order by S.ID Desc
 ) S
 Left Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=AL.ActionCode)
 Left Join ActionFlow nA on (nA.ActionCodeSrc=AL.ActionCode and coalesce(nA.Condition,0)>coalesce(A.Condition,0))
 Where AL.ActionCode=@ActionCode 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 --12, 13, 14 for Request Verification don't need Approval Checking and Privilege ALLOWPAYMENTREQUEST/ALLOWRECEIPTREQUEST
 Where ((S.ApprovalLimit>=@Amount and dbo.GetPrivileges(S.ID,@Privileges)=1) or coalesce(@Condition,0) in (0,12,13,14)) 
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


GO


DROP Function fn_GetVoucherActionUser
GO
CREATE Function fn_GetVoucherActionUser(@ActionCode varchar(10), @Voucher varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = Case When R.DebtorF=1 Then 'ALLOWRECEIPT' Else 'ALLOWPAYMENT' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from pVoucher R
 Where R.Voucher=@Voucher

 Select @Condition=nA.Condition
 from SysRequest S
 Inner Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=@ActionCode) 
 Inner Join ActionFlow nA on (nA.ActionCodeSrc=A.ActionCodeDest and nA.Condition>A.Condition)
 Where Param2='FA' and Param6=@Voucher
 order by S.ID Desc

 if @Condition is null 
	Select @Condition=0

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 Where ((S.ApprovalLimit>=@Amount and dbo.GetPrivileges(S.ID,@Privileges)=1))
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


GO

DROP Function fn_GetRequestCreateVoucherActionUser
GO
CREATE Function fn_GetRequestCreateVoucherActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as
 lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   
go


  insert into PatchVersioning
select '1182 Update Script - 19 August 2024 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1182 Update Script - 19 August 2024 (1)'


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


