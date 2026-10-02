if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_SysRequest') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function get_SysRequest
end
GO
Create function get_SysRequest(@P_USERID AS VARCHAR(50), @Group varchar(1), @SDueDate smalldatetime, @EDueDate smalldatetime)     
RETURNS @TempSysRequest TABLE (ID int,Remarks varchar(Max), UserDate	datetime, UserTime varchar(8), USERID varchar(50), Status varchar(1), Param2 varchar(50),Param3	int, Param4	int, Param5	varchar(50),Param6	varchar(50), ActionCode	varchar(10), DueDate	datetime, Name	varchar(100), BranchID	varchar(10))

AS
BEGIN
	if @Group='2' 
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name, SU.Branch
		from SysRequest S
		Left Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5) 
		Left Join ActionList AL on (AL.ActionCode=S.ActionCode) 
		Inner Join SysUser SU on (SU.ID=@P_UserID and (S.Param5=SU.ID or S.Param5=SU.Type or ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	else if @Group='1' 
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name , SU.Branch
		from SysRequest S
		Inner Join SysUser SU  on (SU.ID=@P_UserID and (S.Param5=SU.ID or S.Param5 = SU.Type))				
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	else
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SUSentBy.Name , SUSentBy.Branch 
		from SysRequest S
		Inner Join SysUser SUSentBy on (SUSentBy.ID=@P_UserID and S.UserID=SUSentBy.ID )
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	RETURN
END


go


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PICKUPTASK') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop FUNCTION WF_PICKUPTASK
end
go

Create FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1), @SDueDate smalldatetime, @EDueDate smalldatetime)    
RETURNS TABLE        
AS RETURN (  

Select TOP 500 S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3  
, coalesce(SV.PolicyNo,coalesce(C.PolicyNo,coalesce(A.PolicyNo,''))) as PolicyNo 
, coalesce(SV.CertificateNo,coalesce(C.CertificateNo,coalesce(A.CertificateNo,''))) as CertificateNo   
, S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName
, S.Param5 as SentTo, S.Name as SentToName, S.BranchID SentToBranchID, BranchSentto.name as SentToBranchName
, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
, coalesce(A.Source,'') as Source 
, coalesce(Sv.TOC, coalesce(C.TOC,coalesce(A.TOC,''))) as TOC 
, Param2  as DocType
, Case 
			  When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End    
			  When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End    
              When Param2 = 'CLM' then C.CLAIMNO
              When Param2 = 'SVC' then Sv.ServiceNo
              When Param2 = 'MAR' then Cov.CoverNo 
              When Param2 = 'FA' then coalesce(V.Voucher, Vm.Voucher)
              When Param2 = 'RQ' then R.Request  
              --When Param2 = 'POLH' then P.PolicyNo
              --When Param2 = 'CLMH' then CH.ClaimNo
              --When Param2 = 'GLH' then GL.GuaranteeNo
              else '' 
       End as DocNo   
,      case 
              When Param2 = 'UND' then A.Branch
              When Param2 = 'IT' then A.Branch
              When Param2 = 'CLM' then C.Branch
              When Param2 = 'MAR' then A.Branch
              When Param2 = 'SVC' then Sv.BRANCH
              when Param2 = 'FA' then coalesce(V.Branch, Vm.Branch)
              when Param2 = 'RQ' then R.Branch
       else   ''
       end as BRANCH
,      Case 
              When Param2 = 'UND' then 'Policy Processing'
              When Param2 = 'IT' then 'Inward Treaty'
              When Param2 = 'CLM' then 'Claim'
              When Param2 = 'SVC' then 'Servicing'
              When Param2 = 'MAR' then 'Quotation'
              When Param2 = 'FA' then 'Finance'
              When Param2 = 'RQ' then 'Request'
              When Param2 = 'POLH' then 'Policy Health'
              When Param2 = 'CLMH' then 'Claim Health'
              When Param2 = 'GLH' then 'Guarantee Letter'
              else '(None)' 
       End as AppName       
,      Case 
			  When Param2 = 'UND' then A.RegNO +case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end  + ' (' + Left(A.AName, 50) + ')'    
			  When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'    
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'FA' then coalesce(V.Voucher + ' (' + Left(V.Remarks, 50) + ')', Vm.Voucher + ' (' + Left(Vm.Remarks, 50) + ')')
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              --When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              --When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              --When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
              else '' 
       End as DataNo   
  
from get_SysRequest(@P_USERID, @Group, @SDueDate, @EDueDate) S
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=S.BranchID)           
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA') 
Left Join mVoucher Vm on (Vm.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)  
go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PENDING') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION WF_PENDING
end
GO
CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1), @SDueDate smalldatetime, @EDueDate smalldatetime)  
RETURNS TABLE            
AS RETURN (            
Select TOP 500 S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3 
, coalesce(SV.PolicyNo,coalesce(C.PolicyNo,coalesce(A.PolicyNo,''))) as PolicyNo 
, coalesce(SV.CertificateNo,coalesce(C.CertificateNo,coalesce(A.CertificateNo,''))) as CertificateNo        
,S.USERID as SentBy, S.Name as SentByName, S.BranchID as SentByBranchID, BranchSentBy.name as SentByBranchName
,S.Param5 as SentTo, coalesce(SUType.Description, SU.Name) as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName
, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
, coalesce(A.Source,'') as Source 
, coalesce(Sv.TOC, coalesce(C.TOC,coalesce(A.TOC,''))) as TOC 
, Param2  as DocType
, Case 
			  When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End    
			  When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End    
              When Param2 = 'CLM' then C.CLAIMNO
              When Param2 = 'SVC' then Sv.ServiceNo
              When Param2 = 'MAR' then Cov.CoverNo 
              When Param2 = 'FA' then coalesce(V.Voucher, Vm.Voucher)
              When Param2 = 'RQ' then R.Request  
              --When Param2 = 'POLH' then P.PolicyNo
              --When Param2 = 'CLMH' then CH.ClaimNo
              --When Param2 = 'GLH' then GL.GuaranteeNo
              else '' 
       End as DocNo   
,      case 
              When Param2 = 'UND' then A.Branch
              When Param2 = 'IT' then A.Branch
              When Param2 = 'CLM' then C.Branch
              When Param2 = 'MAR' then A.Branch
              When Param2 = 'SVC' then Sv.BRANCH
              when Param2 = 'FA' then coalesce(V.Branch, Vm.Branch)
              when Param2 = 'RQ' then R.Branch
       else   ''
       end as BRANCH
,	Case 
		When S.Param2 = 'UND' then 'Policy Processing'
		When S.Param2 = 'IT' then 'Inward Treaty'
		When S.Param2 = 'CLM' then 'Claim'
		When S.Param2 = 'SVC' then 'Servicing'
		When S.Param2 = 'MAR' then 'Quotation'
		When S.Param2 = 'FA' then 'Finance'
		When S.Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName	
,      Case 
			 When Param2 = 'UND' then A.RegNO +case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end  + ' (' + Left(A.AName, 50) + ')'   
			  When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'    
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
			  When Param2 = 'FA' then coalesce(V.Voucher + ' (' + Left(V.Remarks, 50) + ')', Vm.Voucher + ' (' + Left(Vm.Remarks, 50) + ')')
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              --When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              --When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              --When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
              else '' 
       End as DataNo      

from get_SysRequest(@P_USERID, '',@SDueDate, @EDueDate) S
Left Join SysUser SU on (SU.ID=S.Param5)
Left Join SysUserType SUTYPE on (SUTYPE.Type=S.Param5)
Left Join Branch BranchSentBy on (BranchSentBy.Branch=s.BranchID)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)    
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA')     
Left Join mVoucher Vm on (Vm.Voucher =S.Param6 and S.Param2='FA')     
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)         

go


  insert into PatchVersioning
select '1292 Update Script - Patch 2025 (7)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1292 Update Script - Patch 2025 (7)'


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