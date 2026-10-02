--31 jul 2017 : Memorial Journal ditambahkan Auto Reverse Journal 
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoReverseF' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN
ALTER TABLE dbo.mVoucher ADD
	AutoReverseF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Reverse Journal (0 : No, 1 : Yes, Will be Reverse Journal Next Month)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'AutoReverseF'
end
go
Update mVoucher Set AutoReverseF=0 Where AutoReverseF is null
go

--31 jul 2017 (1) : PENAMBAHAN TASK DUE PADA SEND MESSAGE
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DueDate' AND Object_ID = Object_ID(N'SysRequest'))
BEGIN
ALTER TABLE dbo.SysRequest ADD
	DueDate datetime NULL
DECLARE @v sql_variant 
SET @v = N'Task Due Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysRequest', N'COLUMN', N'DueDate'
end
GO
Update SysRequest Set DueDate=UserDate Where DueDate is null
go


--SCRIPT WORKFLOW
Drop PROCEDURE QWF_TASKHAuth
GO
Create PROCEDURE QWF_TASKHAuth(@P_USERID AS VARCHAR(50))      
AS      
SELECT 'My Task' as 'Group'  
UNION ALL      
SELECT 'My Subordinate Task' as 'Group'  

GO

Drop PROCEDURE QWF_TASKH
GO
Create PROCEDURE QWF_TASKH(@P_USERID AS VARCHAR(50))      
AS      
SELECT 'My Task' as 'Group'  
GO

Drop PROCEDURE QWF_TASK 
GO
Create PROCEDURE QWF_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))    
AS    
SELECT 'Pickup Task' as 'Category', Count(ID) as 'Count' from WF_PICKUPTASK(@P_USERID, @Group)    
UNION ALL    
SELECT 'Pending' as 'Category', Count(ID) as 'Count' from WF_PENDING(@P_USERID, @Group)    
UNION ALL  
SELECT 'Other' as 'Category', Count(ID) as 'Count' from WF_OTHERTASK(@P_USERID, @Group)    

GO  

Drop PROCEDURE QWF_PICKUP_TASK
GO
CREATE PROCEDURE QWF_PICKUP_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))  
AS  
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PICKUPTASK(@P_USERID, @Group) WF, ActionList   
Where WF.ActionCode=ActionList.ActionCode  
Group By WF.ActionCode, ActionList.Description  

GO  

Drop FUNCTION WF_PICKUPTASK
GO
Create FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))        
RETURNS TABLE        
AS RETURN (        
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,         
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo 
from SysUser SU    
inner join SysRequest S on (S.Param5=SU.ID or S.Param5 = SU.Type)  
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)           
Left Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5)         
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ') and S.Status='' and SU.ID=@P_USERID and S.ActionCode<>''    
and @Group='1' 
Union All    
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo , 
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate       
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo         
from SysUser SU
Left Join SysRequest S on 1=1
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND'))          
Left Join Cover Cov on (A.CNO=Cov.CNO)                              
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')         
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (S.param5 = SU.id and SU.Branch = BranchSentTo.Branch)         
Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5)
Inner Join ActionList on (ActionList.ActionCode=S.ActionCode) 
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ') and S.Status='' and SU.ID=@P_USERID and S.ActionCode<>''    
and @Group='2' and (ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID)
and (ActionList.ActionNotification=0  or (ActionList.ActionNotification>0 and datediff(day,S.UserDate, getdate())>ActionList.ActionNotification))
)  

GO

DROP PROCEDURE QWF_PENDING_TASK
GO
CREATE PROCEDURE QWF_PENDING_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))  
AS  
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PENDING(@P_USERID, @Group) WF, ActionList   
Where WF.ActionCode=ActionList.ActionCode  
Group By WF.ActionCode, ActionList.Description  
  
GO

Drop PROCEDURE QWF_DETAIL_PICKUP_TASK
GO
CREATE PROCEDURE QWF_DETAIL_PICKUP_TASK(@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)  
AS  
Select * from WF_PICKUPTASK(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate order by UserDate desc, UserTime desc  

GO

Drop Procedure QWF_OTHER_TASK
GO
CREATE PROCEDURE QWF_OTHER_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))  
AS  
Select 'Other' as ActionCode, 'Other Tasks' as Description, Count(ID) as 'TaskCount' from WF_OTHER(@P_USERID, @Group) Group By ActionCode    
  
Go 
Drop Procedure QWF_PENDING_TASK
GO
CREATE PROCEDURE QWF_PENDING_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))
AS
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PENDING(@P_USERID, @Group) WF, ActionList 
Where WF.ActionCode=ActionList.ActionCode
Group By WF.ActionCode, ActionList.Description

GO

Drop Procedure QWF_PICKUP_TASK
GO
CREATE PROCEDURE QWF_PICKUP_TASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))
AS
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PICKUPTASK(@P_USERID, @Group) WF, ActionList 
Where WF.ActionCode=ActionList.ActionCode
Group By WF.ActionCode, ActionList.Description

GO

Drop procedure QWF_ASSIGNUSER
GO  
CREATE PROCEDURE QWF_ASSIGNUSER(@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10))  
AS  
SELECT S.ID, S.NAME, S.TYPE FROM (  
SELECT ID, NAME, 'U' AS TYPE FROM SYSUSER WHERE ALLOWEDF=1 UNION ALL SELECT TYPE AS ID, DESCRIPTION AS NAME, 'T' AS TYPE FROM SYSUSERTYPE) S,  
ACTIONUSER A WHERE (A.ACTIONUSERAUTH_1=@P_USERID OR A.ACTIONUSERAUTH_2=@P_USERID OR A.ACTIONUSERAUTH_3=@P_USERID OR A.ACTIONUSERAUTH_4=@P_USERID OR A.ACTIONUSERAUTH_5=@P_USERID OR A.ACTIONUSERAUTH_6=@P_USERID OR A.ACTIONUSERAUTH_7=@P_USERID OR A.ACTIONUSERAUTH_8=@P_USERID OR A.ACTIONUSERAUTH_9=@P_USERID OR A.ACTIONUSERAUTH_10=@P_USERID) AND A.ACTIONUSER=S.ID   
AND A.ACTIONCODE=@P_ACTIONCODE  

GO


DROP FUNCTION WF_PENDING
GO
CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))            
RETURNS TABLE            
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, Coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,            
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo 
from SysRequest S            
Left Join Acceptance A on (A.ANO=S.Param3) 
Left Join Cover Cov on (A.CNO=Cov.CNO)                              
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')     
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')   
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)        
Left Join SysUser SU on (SU.id = S.Param5)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)           
Left Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.userid)           
Where S.Param1='SEND' and S.Status='' and S.ActionCode<>''        
and @Group='1' and S.UserID=@P_USERID        
Union All        
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,            
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo 
from SysRequest S            
Left Join Acceptance A on (A.ANO=S.Param3) 
Left Join Cover Cov on (A.CNO=Cov.CNO)                                         
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')        
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')    
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)        
Left Join SysUser SU on (SU.id = S.Param5)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)                
Left Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.userid)           
Where S.Param1='SEND' and S.Status='' and S.ActionCode<>''        
and @Group<>'1' and (ActionUser.ActionUserAuth_1=@P_USERID or ActionUser.ActionUserAuth_2=@P_USERID or ActionUser.ActionUserAuth_3=@P_USERID or ActionUser.ActionUserAuth_4=@P_USERID or ActionUser.ActionUserAuth_5=@P_USERID or ActionUser.ActionUserAuth_6=@P_USERID or ActionUser.ActionUserAuth_7=@P_USERID or ActionUser.ActionUserAuth_8=@P_USERID or ActionUser.ActionUserAuth_9=@P_USERID or ActionUser.ActionUserAuth_10=@P_USERID)
Union All        
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,            
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo 
from SysRequest S            
Left Join Acceptance A on (A.ANO=S.Param3)  
Left Join Cover Cov on (A.CNO=Cov.CNO)                                                 
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')   
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)        
Left Join SysUser SU on (SU.id = S.Param5)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)               
Left Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.userid)           
Where S.Param1='SEND' and S.Status='' and (Param3 <> 0 or s.Param4 <> 0)  and (S.ActionCode='' or s.ActionCode is null)  
and @Group='1' and S.USERID=@P_USERID       
)         

GO

Drop FUNCTION WF_Pending_OTHER
GO
Create FUNCTION WF_Pending_OTHER(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))                
RETURNS TABLE                
AS RETURN (                
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,               
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo 
from SysUser SU
inner join SysRequest S on (SU.ID = S.Userid)            
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND'))    
Left Join Cover Cov on (A.CNO=Cov.CNO)                                
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')               
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')         
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ') 
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)          
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ') and S.Status='' and SU.ID=@P_USERID and  (s.Param3<>0 or s.Param4 <> 0) and (S.ActionCode='' or S.ActionCode is null)          
)             

GO

Drop PROCEDURE QWF_DETAIL_PENDING_TASK
GO
CREATE PROCEDURE QWF_DETAIL_PENDING_TASK(@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)    
AS    
SELECT * from (  
Select * from WF_PENDING(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE  and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%')  and DueDate between @SDueDate and @EDueDate
union all    
Select * from WF_Pending_OTHER(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate
) A  
order by UserDate desc, UserTime desc  

GO

DROP FUNCTION WF_OTHER
GO
CREATE FUNCTION WF_OTHER(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))          
RETURNS TABLE          
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo, 
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		else '' 
	End as DataNo  
from SysUser SU
inner join SysRequest S on (S.Param5=SU.ID or S.Param5 = SU.Type)              
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND'))    
Left Join Cover Cov on (A.CNO=Cov.CNO)                   
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')         
Inner Join SysUser SUSentBy on (S.userid = SUSentBy.ID And SU.ShariaF = SUSentBy.ShariaF)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)      
Where S.Param1='SEND' and S.Status='' and SU.ID = @P_USERID  
and S.param2 <> ''
and (S.ActionCode is NULL or S.ActionCode = '')       
and '1' = @Group      
)  

GO

DROP FUNCTION WF_OTHERTASK
GO
CREATE FUNCTION WF_OTHERTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))              
RETURNS TABLE              
AS RETURN (              
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,             
coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo,           
Case When A.AName is null then Sv.Insured  end as AName ,             
S.UserID as SentBy, S.Param5 as SentTo, S.Status, S.Param2, S.Param4, S.ActionCode, S.DueDate             
from SysUser SU, SysRequest S            
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND'))             
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')             
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')           
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ') and S.Status='' and SU.ID=@P_USERID and (S.Param5 = SU.ID or S.Param5 = SU.Type) and (S.ActionCode=''   or S.ActionCode is null)      
)           

GO

Drop PROCEDURE QWF_DETAIL_OTHER_TASK
GO
CREATE PROCEDURE QWF_DETAIL_OTHER_TASK(@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)    
AS    
Select * from WF_OTHER(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate  order by UserDate desc, UserTime desc   
GO



  


--31 jul 2017 (2) : Policy Wording
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WordingPIC]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[WordingPIC](
	[WordingID] [varchar](10) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [text] NULL,
	[Last_Opr] [varchar](10) NULL,
	[Last_Update] [smalldatetime] NULL,
	[AttachmentF] [bit] NULL,
 CONSTRAINT [I_WordingPIC] PRIMARY KEY CLUSTERED 
(
	[WordingID] ASC,
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[WordingPIC]  WITH CHECK ADD  CONSTRAINT [FK_WordingPIC_Wording] FOREIGN KEY([WordingID])
REFERENCES [dbo].[Wording] ([WordingID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[WordingPIC] CHECK CONSTRAINT [FK_WordingPIC_Wording]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Wording ID (see Wording)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'WordingID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'ImageID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'FileType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'Title'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'Remark'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Use as Policy Wording Attachment (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingPIC', @level2type=N'COLUMN',@level2name=N'AttachmentF'
end
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WordingTOC]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[WordingTOC](
	[WordingID] [varchar](10) NOT NULL,
	[TOC] [varchar](10) NOT NULL,
 CONSTRAINT [I_WordingTOC] PRIMARY KEY CLUSTERED 
(
	[WordingID] ASC,
	[TOC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[WordingTOC]  WITH CHECK ADD  CONSTRAINT [FK_WordingTOC_Wording] FOREIGN KEY([WordingID])
REFERENCES [dbo].[Wording] ([WordingID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[WordingTOC] CHECK CONSTRAINT [FK_WordingTOC_Wording]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Virtual Account ID (see VAccount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingTOC', @level2type=N'COLUMN',@level2name=N'WordingID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Wording ID (see Wording)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WordingTOC', @level2type=N'COLUMN',@level2name=N'TOC'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PWordingID' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD
	PWordingID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Policy Wording ID (see Wording Type N)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'PWordingID'
end
GO


DROP Procedure qPolicy_Data
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                             
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
Interest.Currency, Interest.TSI, Interest.ATSI,                              
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
WHERE A1.ANO=@P_ANO 

GO

DROP Procedure QCertificate_Data
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                               
Interest.Currency, Interest.TSI, Interest.ATSI,                            
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
WHERE A1.ANO=@P_ANO       



go

--31 jul 2017 (3) : Perbaikan bugs Terkait dengan prorata Date dan Time


DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)              
as              
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(0 as BIT))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)     
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and 'B'+A6.BSType=A1.Type)       
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F') or A1.TYPE in ('IC') AND A1.CODE IN ('D'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J') 

GO
DROP Procedure PCALC01
GO
CREATE Procedure PCALC01(@P_ANO integer)    
As    
SELECT  ACCEPTANCE.TOC,    
  COVER.PPERIOD,    
  COVER.PRORATA,    
  COVER.VOYAGE,    
  CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
  RCOVER.CODE,    
  RATECOV.TOR,    
  RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
  RCOVER.LOADING,    
  CASE 
  WHEN RCOVER.UNIT='L' Then 0 
  WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*DBO.FN_RATE_LOADING(RCOVER.ANO)
  ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION
  END AS RATE,
  RATECOV.PORTION,    
  RCOVER.SDATE,    
  RCOVER.EDATE,    
  RCOVER.PCALC,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,    
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 0 else RCOVER.PADDITION end as PADDITION,    
  CASE WHEN ICOVER.NOTFLF=1 THEN 100 ELSE RCOVER.PPRORATA END AS PPRORATA,
  ICOVER.CURRENCY,    
  ICOVER.SI,    
  ICOVER.INDEMNITY,    
  (Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
  ICOVER.Adjustable,    
  ICOVER.PCTADJ,    
  ICOVER.INO,    
  ACCEPTANCE.ANO as SANO,    
  PolicyType.SType
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, ACCEPTANCE, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)    
WHERE  ACCEPTANCE.ANO=@P_ANO    
  And COVER.CNO=ACCEPTANCE.CNO    
  And RCLASS.TOC=ACCEPTANCE.TOC    
  And RCOVER.ANO=ACCEPTANCE.ANO    
  And ICOVER.ANO=ACCEPTANCE.ANO    
  And RATECOV.CODE=RCOVER.CODE    
  And RCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOR=RATECOV.TOR    
  And PCLASS.TOI=ICOVER.TOI    
  And TOI.TOI=ICOVER.TOI    
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE, ACCEPTANCE.ANO

GO

DROP FUNCTION DISPLAY_PRORATA_CALCULATION
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
RETURNS TABLE  AS        
RETURN (        
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>=0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
     when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
  Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			convert(varchar(25),DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
		end
  Else        
   ''        
  End        
    Else        
  Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			convert(varchar(25),DateDiff(day, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
		End
  Else        
   ''        
  End        
          
    End        
  End        
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>=0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
     when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
  Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			Cast(DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
		End
  Else        
1        
  End        
    Else        
  Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			Cast(DateDiff(Day, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(Day,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)
		End
  Else        
1        
  End        
          
    End        
  End        
 End        
Else        
1        
End        
          
                      
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0))))
and Acceptance.ANO=@P_ANO        
          
Union All        
          
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			convert(varchar(25),DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(month, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(month,RCalc.sdate,RCalc.edate))        
		End
    Else        
     ''        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			convert(varchar(25),DateDiff(day, acceptance.pdate, dateadd(day,1,RCalc.edate)))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,dateadd(day,1,RCalc.edate)))        
		Else
			convert(varchar(25),DateDiff(day, acceptance.pdate, RCalc.edate))+'/'+convert(varchar(25),datediff(day,RCalc.sdate,RCalc.edate))        
		End
    Else        
     ''        
    End        
            
      End        
    Else        
     -- Endorsement Period        
      ''        
    End        
  End        
end,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        
Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
  When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
      case        
       when day(acceptance.pdate)=day(RCalc.edate) and day(RCalc.sdate)=day(RCalc.edate) and Cover.PPeriod<>1 and datediff(month,RCalc.sdate,RCalc.edate)<>0 then        
    Case When DateDiff(month, acceptance.pdate, RCalc.edate)<>datediff(month,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			Cast(DateDiff(month, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(month,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(month, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(month,RCalc.sdate,RCalc.edate) as Float)        
		End
    Else        
 1        
    End        
      Else        
    Case When DateDiff(day, acceptance.pdate, RCalc.edate)<>datediff(day,RCalc.sdate,RCalc.edate) then        
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			Cast(DateDiff(Day, acceptance.pdate, dateadd(day,1,RCalc.edate)) as Float)/Cast(datediff(Day,RCalc.sdate,dateadd(day,1,RCalc.edate)) as Float)        
		Else
			Cast(DateDiff(Day, acceptance.pdate, RCalc.edate) as Float)/Cast(datediff(Day,RCalc.sdate,RCalc.edate) as Float)        
		End
    Else        
 1        
    End        
            
      End        
    Else        
     -- Endorsement Period        
 1        
    End        
  End        
End        
          
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2,4) and coalesce(RCover.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       
GO


DROP FUNCTION PREMIUM_CALCULATION_FACTOR
GO
CREATE FUNCTION PREMIUM_CALCULATION_FACTOR(@P_ANO int)    
RETURNS TABLE  AS    
RETURN (    
Select ANO, Currency, sum(Premium) as Premium    
                                
from(    
 Select ANO, Currency, sum(Premium) as Premium    
                        
 from (    
  select Acceptance.ANO, RCalc.Currency,    
  case    
  When Acceptance.AType<>'N' then    
   case    
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0    
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1    
   Else    
    case    
    when acceptance.cpct<>0 or Cover.Voyage=1 then    
     case    
     when acceptance.cpct<>0 then    
      acceptance.cpct/100    
     Else    
1    
     End    
    Else    
     case    
     when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then    
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			convert(float,DateDiff(month, acceptance.pdate, dateadd(day,1,rcalc.edate)))/convert(float,datediff(month,rcalc.sdate,dateadd(day,1,rcalc.edate)))    
		Else
			convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))    
		End
     Else  
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then  
			convert(float,DateDiff(day, acceptance.pdate, dateadd(day,1,rcalc.edate)))/convert(float,datediff(day,rcalc.sdate,dateadd(day,1,rcalc.edate)))    
		Else
			convert(float,DateDiff(day, acceptance.pdate, rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))    
		End
     End    
    End    
   End    
  Else    
1    
  End    
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)    
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) * 1/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER    
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO    
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE    
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency    
  and Acceptance.AType not in ('A','C')    
  and Acceptance.NoRefundF not in (2,4) and (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))      
  and RCalc.Gross<>0    
                                      
  Union All    
                                                                      
  select Acceptance.ANO, RCalc.Currency,    
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*1/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'            
 ) T    
                        
 Group By ANO, Currency    
                                                                                   
) T    
                                
Group By ANO, Currency    
                                    
                                    
)    

GO

DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
Else 
case 
when acceptance.cpct<>0 or Cover.Voyage=1 then 
		case 
		when acceptance.cpct<>0 then 
		   acceptance.cpct/100 
		Else 
			1 
		End 
Else 
		case 
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then 
			 case 
			 when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then 
				Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
					convert(float,DateDiff(month, acceptance.pdate, dateadd(day,1,rcalc.edate)))/convert(float,datediff(month,rcalc.sdate,dateadd(day,1,rcalc.edate))) 
				Else
					convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate)) 
				End
			 Else 
				Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
					convert(float,DateDiff(day, acceptance.pdate,dateadd(day,1,rcalc.edate)))/convert(float,datediff(day,rcalc.sdate,dateadd(day,1,rcalc.edate))) 
				Else
					convert(float,DateDiff(day, acceptance.pdate,rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate)) 
				End
			 End 
		Else 
		-- Endorsement Period 
			1 
		End 
End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Acceptance.NoRefundF not in (2,4) and ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)) 
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*
(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 

go


--31 jul 2017 (4) : SETTING POLICY WORDING DI TYPE OF PRODUCT
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'WordingID' AND Object_ID = Object_ID(N'TOPRO'))
BEGIN
ALTER TABLE dbo.TOPRO ADD
	WordingID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Wording ID (see Wording)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'WordingID'
end
go

--4 agst 2017 : f2 TOC
drop function [dbo].[FL_SR_TOC]
go
create function [dbo].[FL_SR_TOC](@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(
Select distinct TOC.TOC,TOC.Description 
From TOC, PTClass, SysUserTOC S 
Where TOC.AllowedF=1 and S.ID=@P_USERID 
and S.TOC=TOC.TOC and PTClass.COB=TOC.COB 
and PTClass.PolicyType like @P_PolicyType+'%' 
and (TOC.TOC like @P_TOC+'%' or TOC.DESCRIPTION  like @P_TOC+'%')
)
go


--VERSIONING
insert into versioning
select '2017 V.2.4.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
