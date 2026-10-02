
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AppLimitOutOption' AND Object_ID = Object_ID(N'TOC'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.TOC ADD
	AppLimitOutOption varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Approval Limit Out Option (''Default'', ''LimitOut'', ''LimitOut-1'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'AppLimitOutOption'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LimitOut_1' AND Object_ID = Object_ID(N'TOC'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUserTOC ADD
	LimitOut_1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max. Claim Authorization Limit Amount (see Approval Limit Out Option in TOC for LimitOut-1 Option)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserTOC', N'COLUMN', N'LimitOut_1'
end
GO


DROP Function GetApprovalLimit
GO
CREATE Function GetApprovalLimit(@UserID varchar(50), @TOC varchar(10), @ISType varchar(1), @InOut varchar(10), @Branch varchar(10), @ApprLimitPct Float)
RETURNS Float AS        
BEGIN      
	Declare @BType as varchar(10)
	Declare @UType as varchar(10)
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	if @ApprLimitPct=0 
		Select @ApprLimitPct=100

	If @ISType = 'I' Or @ISType  = 'L' Or @ISType = 'C'
		Select @BType='DIRECT'
	Else
		Select @BType='INDIRECT'

	select 
	@UType=S1.Type,
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @TOC<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserTypeTOC 
		Where Type=@UType and BType=@BType and TOC=@TOC and Effective<=@PDate 
		Order By Effective Desc
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=Case When @InOut='Out_1' and TOC.AppLimitOutOption='LimitOut_1' Then S.LimitOut_1 Else S.LimitOut End 
		from SysUserTOC S Inner Join TOC on (TOC.TOC=S.TOC)
		Where S.ID=@UserID and S.TOC=@TOC and S.Effective<=@PDate 
		Order By S.Effective Desc

		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		if @Branch<>''
		Begin
			Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
			from SysUserTOCBranch 
			Where ID=@UserID and TOC=@TOC and Branch=@Branch and Effective<=@PDate 
			Order By Effective Desc

			if @tempLimitIn<>0 
				Select @LimitIn=@TempLimitIn

			if @tempLimitOut<>0 
				Select @LimitOut=@tempLimitOut
		end
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn*@ApprLimitPct/100
	else
		Select @ApprovalLimit=@LimitOut*@ApprLimitPct/100

	return @ApprovalLimit
END        


GO

DROP Function fn_GetClaimApprovalActionUser
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
 Declare @ApprovalLimit Float

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
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out_1', @Branch,0) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End 




go



 insert into PatchVersioning	
select '700 Update Script - 13 July 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='700 Update Script - 13 July 2023'


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



