SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PICKUPTASK') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION WF_PICKUPTASK END
GO

CREATE FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1), @SDueDate smalldatetime, @EDueDate smalldatetime)    
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
			  When Param2 = 'UND-MW' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End     
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
			  When Param2 = 'UND-MW' then A.Branch
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
			  When Param2 = 'UND-MW' then 'Policy Processing MW'
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
			  When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')' 
			  When Param2 = 'UND-MW' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')' 
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
	   , Case 
			  When Param2 = 'UND' then 
					Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    
			When Param2 = 'UND-MW' then 
					Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    
			  When Param2 = 'IT' then 
			  Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    
              When Param2 = 'CLM' then 
			  Case 
					When C.CSTATUS='A' Then 'Approved' 
					When C.CSTATUS='R' Then 'Request' 
					When C.CSTATUS='P' Then 'Processed' 
					When C.CSTATUS='T' Then 'Reviewed' 
					When C.CSTATUS='C' Then 'Closed' 
					When C.CSTATUS='D' Then 'Declined' 
					Else '' End    
              When Param2 = 'SVC' then  
			  Case 
					When SV.SStatus='A' Then 'Approved' 
					When SV.SStatus='R' Then 'Request' 
					When SV.SStatus='P' Then 'Released' 
					When SV.SStatus='T' Then 'Reviewed' 
					When SV.SStatus='C' Then 'Cancelled/Closed' 
					Else '' End    
              When Param2 = 'MAR' then 
			   Case 
					When Cov.CStatus='A' Then 'Accepted' 
					When Cov.CStatus='R' Then 'Request' 
					When Cov.CStatus='P' Then 'Released' 
					When Cov.CStatus='C' Then 'Cancelled/Closed' 
					Else '' End    
              When Param2 = 'FA' then 
			    Case 
					When V.Status='U' or VM.Status='U' Then 'Approved' 
					When V.Status='P' or VM.Status='P' Then 'Posted' 
					When V.Status='N' or VM.Status='N' Then 'Not Approved' 
					When V.Status='V' or VM.Status='V' Then 'Verified' 
					Else '' End    
              When Param2 = 'RQ' then 
			   Case 
					When R.Status='P' Then 'Approved' 
					When R.Status='R' Then 'Request' 
					When R.Status='V' Then 'Verified'
					When R.Status='C' Then 'Cancelled' 
					Else '' End    
              --When Param2 = 'POLH' then P.PolicyNo
              --When Param2 = 'CLMH' then CH.ClaimNo
              --When Param2 = 'GLH' then GL.GuaranteeNo
              else '' 
       End as Status_Transasction   
from get_SysRequest(@P_USERID, @Group, @SDueDate, @EDueDate) S
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=S.BranchID)           
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','UND-MW','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA') 
Left Join mVoucher Vm on (Vm.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)  


GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PENDING') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION WF_PENDING END
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
			  When Param2 = 'UND-MW' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End 
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
			  When Param2 = 'UND-MW' then A.Branch
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
		When S.Param2 = 'UND-MW' then 'Policy Processing MW'
		When S.Param2 = 'IT' then 'Inward Treaty'
		When S.Param2 = 'CLM' then 'Claim'
		When S.Param2 = 'SVC' then 'Servicing'
		When S.Param2 = 'MAR' then 'Quotation'
		When S.Param2 = 'FA' then 'Finance'
		When S.Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName	
,      Case 
			 When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'   
			 When Param2 = 'UND-MW' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'
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

	    , Case 
			  When Param2 = 'UND' then 
					Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    
				When Param2 = 'UND-MW' then 
					Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    
			  When Param2 = 'IT' then 
			  Case 
					When A.ASTATUS='I' Then 'Inforced' 
					When A.ASTATUS='T' Then 'Reviewed' 
					When A.ASTATUS='W' Then 'Waiting' 
					When A.ASTATUS='C' Then 'Closed' 
					Else '' End    

              When Param2 = 'CLM' then 
			  Case 
					When C.CSTATUS='A' Then 'Approved' 
					When C.CSTATUS='R' Then 'Request' 
					When C.CSTATUS='P' Then 'Processed' 
					When C.CSTATUS='T' Then 'Reviewed' 
					When C.CSTATUS='C' Then 'Closed' 
					When C.CSTATUS='D' Then 'Declined' 
					Else '' End    
              When Param2 = 'SVC' then  
			  Case 
					When SV.SStatus='A' Then 'Approved' 
					When SV.SStatus='R' Then 'Request' 
					When SV.SStatus='P' Then 'Released' 
					When SV.SStatus='T' Then 'Reviewed' 
					When SV.SStatus='C' Then 'Cancelled/Closed' 
					Else '' End    

              When Param2 = 'MAR' then 
			   Case 
					When Cov.CStatus='A' Then 'Accepted' 
					When Cov.CStatus='R' Then 'Request' 
					When Cov.CStatus='P' Then 'Released' 
					When Cov.CStatus='C' Then 'Cancelled/Closed' 
					Else '' End    

              When Param2 = 'FA' then 
			    Case 
					When V.Status='U' or VM.Status='U' Then 'Approved' 
					When V.Status='P' or VM.Status='P' Then 'Posted' 
					When V.Status='N' or VM.Status='N' Then 'Not Approved' 
					When V.Status='V' or VM.Status='V' Then 'Verified' 
					Else '' End    

              When Param2 = 'RQ' then 
			   Case 
					When R.Status='P' Then 'Approved' 
					When R.Status='R' Then 'Request' 
					When R.Status='V' Then 'Verified'
					When R.Status='C' Then 'Cancelled' 
					Else '' End    

              --When Param2 = 'POLH' then P.PolicyNo
              --When Param2 = 'CLMH' then CH.ClaimNo
              --When Param2 = 'GLH' then GL.GuaranteeNo
              else '' 
       End as Status_Transasction   
from get_SysRequest(@P_USERID, '',@SDueDate, @EDueDate) S
Left Join SysUser SU on (SU.ID=S.Param5)
Left Join SysUserType SUTYPE on (SUTYPE.Type=S.Param5)
Left Join Branch BranchSentBy on (BranchSentBy.Branch=s.BranchID)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)    
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','UND-MW','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA')     
Left Join mVoucher Vm on (Vm.Voucher =S.Param6 and S.Param2='FA')     
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)         

GO

insert into PatchVersioning
select '1465 UPDATE SCRIPT WF CGISS PENAMBAHAN MW',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1465 UPDATE SCRIPT WF CGISS PENAMBAHAN MW'


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