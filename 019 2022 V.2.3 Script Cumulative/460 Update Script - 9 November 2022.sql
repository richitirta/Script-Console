

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	Last_Time varchar(8) NULL
DECLARE @v sql_variant 
SET @v = N'Last User Update Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'Last_Time'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestF' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	RequestF bit NULL
DECLARE @v sql_variant 
SET @v = N'Request Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'RequestF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestMessage' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	RequestMessage varchar(MAX) NULL
DECLARE @v sql_variant 
SET @v = N'Branch Request Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'RequestMessage'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestName' AND Object_ID = Object_ID(N'AINFODET'))
BEGIN
ALTER TABLE dbo.AINFODET ADD
	RequestName varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Request Sent Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AINFODET', N'COLUMN', N'RequestName'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_ReinsuranceRate') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION get_ReinsuranceRate END
GO
CREATE Function get_ReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10))          
RETURNS Float AS        
  
BEGIN       
Declare @BaseCCY as varchar(10)
Declare @CCY as varchar(10)
Declare @CCYTO as varchar(10)
Declare @Rate as Float
Declare @TRate as Float
Declare @ExitLoop as bit
Declare @Tab as table(CCYTO varchar(10), Rate FLoat)

Select @ExitLoop=0
Select @Rate=1
Select @BaseCCY=sysTab.Currency from SysTab
Select @CCYTO=@P_Currency

if @P_Currency<>@BaseCCY
BEGIN
	WHILE @ExitLoop=0
	BEGIN
		Select @CCY=@CCYTO

		SELECT 
		@CCYTO=coalesce(ReRate.CCYTo,''),
		@TRate=Case 
		When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
		Else 
			Case
			When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@CCY Then 
				Case When @CCY<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@CCY) else 1 end
			Else
				Case When @CCY<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@CCY) else 1 end
				/
				Case When @CCY<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
			End
		end
		From SysTab
		Left Join ReRate on 
		(
		ReRate.TOC=@P_TOC
		and ReRate.Currency=@CCY
		and ReRate.RYear=coalesce((   
			 Select Top 1 R1.RYear   
			 from Reinsurance R1, ReClass R2   
			 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
			 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
			 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 
		)

		Select @Rate=@Rate*@TRate

		if @CCYTO=@CCY or @CCYTO='' or @CCYTO=@BaseCCY 
		Begin
			Select @ExitLoop=1
		End
	END	
END

return @Rate  
END        




GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetObjectRegisterActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION fn_GetObjectRegisterActionUser END
GO

CREATE Function fn_GetObjectRegisterActionUser(@ActionCode varchar(10), @ObjectID varchar(50))   
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
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=A1.TOC,
 @Branch=A1.Branch,
 @ISType=C.ISType,
 @Amount=A2.Limit*dbo.get_ReinsuranceRate(A1.TOC, A2.Currency, cast(convert(varchar(10), getdate(),1) as smalldatetime),C.PHOLDER)          ,
 @ApprLimitPCT=100
 from AInfoDet A2
 Inner Join Acceptance A1 on (A1.ANO=A2.ANO)
 Inner join Cover C on (C.CNO=A1.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A1.Source) 
 where C.CNO=A1.CNO and A2.ANO=A1.ANO 
 and cast(A2.ANO as varchar(10))+'-'+A2.FLDID+'-'+A2.VALUEID=@ObjectID 
 Order By A2.SeqNo Desc

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
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
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
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
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

 Select top 1 @ApprovalLimit=T.ApprovalLimit 
 from @T T
 Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('UND-OBJ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where abs(T.ApprovalLimit-@ApprovalLimit)<=1

Return   
End   





GO


 insert into PatchVersioning
select '460 Update Script - 9 November 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='460 Update Script - 9 November 2022'


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
