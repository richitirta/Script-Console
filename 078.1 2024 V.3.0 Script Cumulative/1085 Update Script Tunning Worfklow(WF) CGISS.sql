IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestTBranch') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestTBranch
end
go
CREATE Function fn_SysRequestTBranch(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @TBranch varchar(10) 


if @Param2='UND' OR @Param2='IT'
Begin 
	  Select @TBranch= A.Branch
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
else if @Param2='MAR'
Begin 
	  Select 
	  @TBranch= A.Branch
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  Select 
	  @TBranch= SV.Branch
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  Select 
	  @TBranch= C.Branch
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA'  
BEGIN 
	  Select 
	  @TBranch= V.Branch
	  From 	 Voucher V
	  Where V.Voucher =@Param6 
END 

ELSE if @Param2='RQ'  
BEGIN 
	  Select 
	  @TBranch= R.Branch
	  From 	 Request R
	  Where R.Request =@Param6 
END 

return(@TBranch) 
End 



GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestDataNo') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestDataNo
end
go
CREATE Function fn_SysRequestDataNo(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(256) 
AS 
 
BEGIN 
Declare @DataNo varchar(256) 


if @Param2='UND' OR @Param2='IT'
Begin 
	  Select @DataNo=  A.RegNO + ' (' + Left(A.AName, 50) + ')'
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
else if @Param2='MAR'
Begin 
	  Select 
	  @DataNo= Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  Select 
	  @DataNo=  Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  Select 
	  @DataNo= C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA'  
BEGIN 
	  Select 
	  @DataNo= V.Voucher + ' (' + Left(V.Remarks, 50) + ')'
	  From 	 Voucher V
	  Where V.Voucher =@Param6 
END 

ELSE if @Param2='RQ'  
BEGIN 
	  Select 
	  @DataNo= R.Request + ' (' + Left(R.Remarks, 50) + ')'
	  From 	 Request R
	  Where R.Request =@Param6 
END 

return(@DataNo) 
End 



GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestPolicyNo') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestPolicyNo
end
go
CREATE Function fn_SysRequestPolicyNo(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(50) 
AS 
 
BEGIN 
Declare @PolicyNo varchar(50) 


if @Param2='UND' OR @Param2='IT' OR @Param2='MAR'
Begin 
	  Select @PolicyNo= A.POLICYNO
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  Select 
	  @PolicyNo= SV.PolicyNo
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  Select 
	  @PolicyNo= C.PolicyNo
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA' OR @Param2='RQ'
BEGIN 
	  Select 
	  @PolicyNo= ''
	 
END 


return(@PolicyNo) 
End 



GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestCERTIFICATENO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestCERTIFICATENO
end
go
CREATE Function fn_SysRequestCERTIFICATENO(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(20) 
AS 
 
BEGIN 
Declare @CERTIFICATENO varchar(20) 


if @Param2='UND' OR @Param2='IT' OR @Param2='MAR'
Begin 
	  Select @CERTIFICATENO= A.CERTIFICATENO
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  Select 
	  @CERTIFICATENO= SV.CERTIFICATENO
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  Select 
	  @CERTIFICATENO= C.CERTIFICATENO
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA'   OR @Param2='RQ'
BEGIN 
	  Select 
	  @CERTIFICATENO= ''
	  
END 

return(@CERTIFICATENO) 
End 



GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestTOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestTOC
end
go
CREATE Function fn_SysRequestTOC(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @TOC varchar(10) 


if @Param2='UND' OR @Param2='IT' OR @Param2='MAR'
Begin 
	  Select @TOC= A.TOC
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  Select 
	  @TOC= SV.TOC
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  Select 
	  @TOC= C.TOC
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA' OR @Param2='RQ' 
BEGIN 
	  Select 
	  @TOC= ''
	  
END 


return(@TOC) 
End 



GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestSource') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestSource
end
go
CREATE Function fn_SysRequestSource(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @Source varchar(10) 


if @Param2='UND' OR @Param2='IT' OR @Param2='MAR'
Begin 
	  Select @Source= A.Source
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 

ELSE if @Param2='CLM' OR @Param2='SVC' OR @Param2='FA' OR @Param2='RQ' 
BEGIN 
	  Select 
	  @Source= ''
	  
END 


return(@Source) 
End 



GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SysRequestDetail') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_SysRequestDetail
end
go
CREATE Function fn_SysRequestDetail(@Param2 varchar(50),@Param3	int, @Param4 int,@Param6	varchar(50)) 
RETURNS @Detail_SysRequest TABLE (PolicyNo varchar(50), CERTIFICATENO varchar(20), Branch	varchar(10), DataNo	varchar(256), TOC	varchar(10), Source Varchar(10))
AS
 
BEGIN 

if @Param2='UND' OR @Param2='IT'
Begin 
	  insert into @Detail_SysRequest
	  Select 
	  A.PolicyNo, A.CERTIFICATENO, A.Branch, A.RegNO + ' (' + Left(A.AName, 50) + ')' AS DataNo, A.TOC,coalesce(A.SOURCE,'')
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
else if @Param2='MAR'
Begin 
	  insert into @Detail_SysRequest
	  Select 
	  A.PolicyNo, A.CERTIFICATENO, A.Branch,  Cov.CoverNo + ' (' + Left(A.AName, 50) + ')' AS DataNo, A.TOC,coalesce(A.SOURCE,'')
	  From 	 Acceptance A       
	  inner Join Cover Cov on (A.CNO=Cov.CNO)
	  Where A.ANO=@Param3 
	 
End 
ELSE if @Param2='SVC'  
BEGIN 
	  insert into @Detail_SysRequest
	  Select 
	  SV.PolicyNo, SV.CERTIFICATENO, SV.Branch, Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')' AS DataNo, SV.TOC,''
	  From 	 Service Sv
	  Where SV.SNO=@Param3 
END 

ELSE if @Param2='CLM'  
BEGIN 
	  insert into @Detail_SysRequest
	  Select 
	  C.PolicyNo, C.CERTIFICATENO, C.Branch, C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')' AS DataNo, C.TOC,''
	  From 	 Claim C
	  Where C.CNO=@Param4 
END 

ELSE if @Param2='FA'  
BEGIN 
	  insert into @Detail_SysRequest
	  Select 
	  '', '', V.Branch, V.Voucher + ' (' + Left(V.Remarks, 50) + ')' AS DataNo, '',''
	  From 	 Voucher V
	  Where V.Voucher =@Param6 
END 

ELSE if @Param2='RQ'  
BEGIN 
	  insert into @Detail_SysRequest
	  Select 
	  '', '', R.Branch, R.Request + ' (' + Left(R.Remarks, 50) + ')' AS DataNo, '',''
	  From 	 Request R
	  Where R.Request =@Param6 
END 
 
RETURN
END

go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_SysRequest') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION get_SysRequest
end
GO
Create function get_SysRequest(@P_USERID AS VARCHAR(50), @Group varchar(1))     
RETURNS @TempSysRequest TABLE (ID int,Remarks varchar(Max), UserDate	datetime, UserTime varchar(8), USERID varchar(50), Status varchar(1), Param2 varchar(50),Param3	int, Param4	int, Param5	varchar(50),Param6	varchar(50), ActionCode	varchar(10), DueDate	datetime, Name	varchar(100), BranchID	varchar(10))

AS
BEGIN


	if @Group='2' 
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name, SU.Branch
		from SysUser SU
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='')
		Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and (ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))
		Inner Join ActionList on (ActionList.ActionCode=S.ActionCode and (ActionList.ActionNotification=0  or (ActionList.ActionNotification>0 and datediff(day,S.UserDate, cast(convert(varchar(10), getdate(),1) as smalldatetime))>ActionList.ActionNotification))) 
		Where SU.ID=@P_USERID 

	End
	else if @Group='1' 
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name , SU.Branch
		from SysUser SU    
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and (S.Param5=SU.ID or S.Param5 = SU.Type) and S.Status='')
		Where SU.ID=@P_USERID 
				
	End
	else
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SUSentBy.Name , SUSentBy.Branch 
		from SysUser SUSentBy    
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.UserID=SUSentBy.ID and S.Status='')
		Where SUSentBy.ID=@P_USERID 

	End
RETURN
END

go




DROP FUNCTION WF_PICKUPTASK
GO
Create FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))        
RETURNS TABLE        
AS RETURN (  

Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  
DBO.fn_SysRequestPolicyNo(S.Param2,S.Param3, S.Param4,S.Param6) AS POLICYNO
, DBO.fn_SysRequestCertificateNo(S.Param2,S.Param3, S.Param4,S.Param6) as CertificateNo
, S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName
, S.Param5 as SentTo, S.Name as SentToName, S.BranchID SentToBranchID, BranchSentto.name as SentToBranchName
, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
, DBO.fn_SysRequestSOURCE(S.Param2,S.Param3, S.Param4,S.Param6) as Source
,DBO.fn_SysRequestTOC(S.Param2,S.Param3, S.Param4,S.Param6) as TOC
,	DBO.fn_SysRequestTBRANCH(S.Param2,S.Param3, S.Param4,S.Param6) As Branch
,   	Case 
		When S.Param2 = 'UND' then 'Policy Processing'
		When S.Param2 = 'IT' then 'Inward Treaty'
		When S.Param2 = 'CLM' then 'Claim'
		When S.Param2 = 'SVC' then 'Servicing'
		When S.Param2 = 'MAR' then 'Quotation'
		When S.Param2 = 'FA' then 'Finance'
		When S.Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName,	
	DBO.fn_SysRequestDataNo(S.Param2,S.Param3, S.Param4,S.Param6)  As DataNo     
from get_SysRequest(@P_USERID, @Group) S
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=S.BranchID)           

)  
GO
DROP FUNCTION WF_PENDING
GO
CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))            
RETURNS TABLE            
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  
DBO.fn_SysRequestPolicyNo(S.Param2,S.Param3, S.Param4,S.Param6)  As PolicyNo, 
DBO.fn_SysRequestCertificateNo(S.Param2,S.Param3, S.Param4,S.Param6)  As  CertificateNo,      
S.USERID as SentBy, S.Name as SentByName, S.BranchID as SentByBranchID, BranchSentBy.name as SentByBranchName,
S.Param5 as SentTo, coalesce(SUType.Description, SU.Name) as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, 
S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate,
DBO.fn_SysRequestTOC(S.Param2,S.Param3, S.Param4,S.Param6)  As TOC , 
DBO.fn_SysRequestSOURCE(S.Param2,S.Param3, S.Param4,S.Param6)  As SOURCE,
DBO.fn_SysRequestTBRANCH(S.Param2,S.Param3, S.Param4,S.Param6)  As BRANCH,   
	Case 
		When S.Param2 = 'UND' then 'Policy Processing'
		When S.Param2 = 'IT' then 'Inward Treaty'
		When S.Param2 = 'CLM' then 'Claim'
		When S.Param2 = 'SVC' then 'Servicing'
		When S.Param2 = 'MAR' then 'Quotation'
		When S.Param2 = 'FA' then 'Finance'
		When S.Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName,	
	DBO.fn_SysRequestDataNo(S.Param2,S.Param3, S.Param4,S.Param6)  As  DataNo        
from get_SysRequest(@P_USERID, '') S
Left Join SysUser SU on (SU.ID=S.Param5)
Left Join SysUserType SUTYPE on (SUTYPE.Type=S.Param5)
Left Join Branch BranchSentBy on (BranchSentBy.Branch=s.BranchID)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)           
)         

go


insert into PatchVersioning
select '1085 Update Script Tunning Worfklow(WF) CGISS',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1085 Update Script Tunning Worfklow(WF) CGISS'


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