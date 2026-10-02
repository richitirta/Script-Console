
insert into PatchVersioning
select '57.28 Update Script WFTask New (1.2)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='57.28 Update Script WFTask New (1.2)'


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
			DROP FUNCTION WF_PICKUPTASK
			DROP FUNCTION WF_PENDING
			DROP PROCEDURE [dbo].[QWF_DETAIL_PICKUP_TASK]
			DROP PROCEDURE [dbo].[QWF_DETAIL_PENDING_TASK]
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


go

Create FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))        
RETURNS TABLE        
AS RETURN (        
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  
--coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo , 
coalesce(SV.PolicyNo,coalesce(C.PolicyNo,A.PolicyNo)) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(C.CertificateNo,A.CertificateNo)) as CertificateNo ,      
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S
.Param4, S.Param6, S.ActionCode, S.DueDate, 
coalesce(A.SOURCE,'') as SOURCE,
COALESCE(coalesce(Sv.TOC, coalesce(C.TOC,A.TOC)),'') as TOC, 
	case 
		When Param2 = 'UND' then A.Branch
		When Param2 = 'IT' then A.Branch
		When Param2 = 'CLM' then C.Branch
		When Param2 = 'MAR' then A.Branch
		When Param2 = 'SVC' then Sv.BRANCH
		when Param2 = 'FA' then V.Branch
		when Param2 = 'RQ' then R.Branch
	else   ''
	end as BRANCH,   
	Case 
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
	End as AppName,	
	Case 
		When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo         
from SysUser SU    
inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and (S.Param5=SU.ID or S.Param5 = SU.Type) and S.Status='')
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)           
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)     
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where SU.ID=@P_USERID and @Group='1' 

Union All

Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  
--coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo , 
coalesce(SV.PolicyNo,coalesce(C.PolicyNo,A.PolicyNo)) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(C.CertificateNo,A.CertificateNo)) as CertificateNo ,      
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S
.Param4, S.Param6, S.ActionCode, S.DueDate,
coalesce(A.SOURCE,'') as SOURCE,
COALESCE(coalesce(Sv.TOC, coalesce(C.TOC,A.TOC)),'') as TOC, 
	case 
		When Param2 = 'UND' then A.Branch
		When Param2 = 'IT' then A.Branch
		When Param2 = 'CLM' then C.Branch
		When Param2 = 'MAR' then A.Branch
		When Param2 = 'SVC' then Sv.BRANCH
		when Param2 = 'FA' then V.Branch
		when Param2 = 'RQ' then R.Branch
	else   ''
	end as BRANCH,   
	Case 
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
	End as AppName,	
	Case 
		When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo         
from SysUser SU
inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='')
Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and (ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))
Inner Join ActionList on (ActionList.ActionCode=S.ActionCode and (ActionList.ActionNotification=0  or (ActionList.ActionNotification>0 and datediff(day,S.UserDate, cast(convert(varchar(10), getdate(),1) as smalldatetime))>ActionList.ActionNotification))) 

Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)           
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)        
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where SU.ID=@P_USERID and @Group='2'
)  
GO





GO
CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))            
RETURNS TABLE            
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  
--coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo , 
coalesce(SV.PolicyNo,coalesce(C.PolicyNo,A.PolicyNo)) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(C.CertificateNo,A.CertificateNo)) as CertificateNo ,      
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, coalesce(SUType.Description, SU.Name) as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate,
coalesce(Sv.TOC, coalesce(C.TOC,A.TOC)) as TOC, coalesce(A.SOURCE,'') as SOURCE,
	case 
		When Param2 = 'UND' then A.Branch
		When Param2 = 'IT' then A.Branch
		When Param2 = 'CLM' then C.Branch
		When Param2 = 'MAR' then A.Branch
		When Param2 = 'SVC' then Sv.BRANCH
		when Param2 = 'FA' then V.Branch
		when Param2 = 'RQ' then R.Branch
	else   ''
	end as BRANCH,   
	Case 
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
	End as AppName,	
	Case 
		When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo         
from SysUser SUSentBy    
inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.UserID=SUSentBy.ID and S.Status='')
Left Join SysUser SU on (SU.ID=S.Param5)
Left Join SysUserType SUTYPE on (SUTYPE.Type=S.Param5)
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)           
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)     
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where SUSentBy.ID=@P_USERID 
)         



go



GO

CREATE PROCEDURE [dbo].[QWF_DETAIL_PICKUP_TASK](@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date, @TOC AS VARCHAR(10), @Branch AS VARCHAR(10), @Sender AS VARCHAR(50), @CINo AS VARCHAR(50), @SOURCE AS VARCHAR(50))  
AS  
Select * from WF_PICKUPTASK(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE AND STATUS='' and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate AND TOC like '%' + @TOC + '%' AND BRANCH like '%' + @Branch + '%' 
AND SentBy like '%' + @Sender + '%'  AND Datano like '%' + @CINo + '%' AND SOURCE LIKE '%' + @SOURCE + '%'  
order by UserDate desc, UserTime desc  


GO

GO

CREATE PROCEDURE [dbo].[QWF_DETAIL_PENDING_TASK](@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date, @TOC AS VARCHAR(10), @Branch AS VARCHAR(10), @Sender AS VARCHAR(50), @CINo AS VARCHAR(50), @SOURCE AS VARCHAR(50))    
AS    
SELECT * from (  
Select * from WF_PENDING(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE AND STATUS='' and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%')  and DueDate between @SDueDate and @EDueDate AND TOC like '%' + @TOC + '%' AND BRANCH like '%' + @Branch + '%' 
AND SentBy like '%' + @Sender + '%'  AND Datano like '%' + @CINo + '%'  AND SOURCE LIKE '%' + @SOURCE + '%' 
) A  
order by UserDate desc, UserTime desc  


GO



