
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PICKUPTASK') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION WF_PICKUPTASK
end
GO
Create FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))        
RETURNS TABLE        
AS RETURN (        
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,         
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S
.Param4, S.Param6, S.ActionCode, S.DueDate ,         
	Case When Param2 = 'UND' then 'Policy Processing'
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
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)     
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='' and SU.ID=@P_USERID 
--and S.ActionCode<>''    
and @Group='1' 
Union All    
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,  coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo , 
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S
.Param4, S.Param6, S.ActionCode, S.DueDate         
,	Case When Param2 = 'UND' then 'Policy Processing'
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
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)        
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5)
Inner Join ActionList on (ActionList.ActionCode=S.ActionCode) 
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='' and SU.ID=@P_USERID 
and S.ActionCode<>''    
and @Group='2' and (ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID)
and (ActionList.ActionNotification=0  or (ActionList.ActionNotification>0 and datediff(day,S.UserDate, getdate())>ActionList.ActionNotification))
)  


GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_PENDING') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION WF_PENDING
end
GO
CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))            
RETURNS TABLE            
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
 coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,            
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,      Case When Param2 = 'UND' then 'Policy Processing'
              When Param2 = 'CLM' then 'Claim'
              When Param2 = 'SVC' then 'Servicing'
              When Param2 = 'MAR' then 'Quotation'
              When Param2 = 'FA' then 'Finance'
              When Param2 = 'RQ' then 'Request'
              --When Param2 = 'POLH' then 'Policy Health'
              --When Param2 = 'CLMH' then 'Claim Health'
              --When Param2 = 'GLH' then 'Guarantee Letter'
              else '(None)' 
       End as AppName   
,      Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)    
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)  
Where @Group='1' 
and S.Param1='SEND' and S.Param2 in ('UND','CLM','MAR','SVC','FA','RQ','POLH','CLMH','GLH') and S.USERID=@P_USERID and S.Status=''

Union All        

Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
 coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,            
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
,      Case When Param2 = 'UND' then 'Policy Processing'
              When Param2 = 'CLM' then 'Claim'
              When Param2 = 'SVC' then 'Servicing'
              When Param2 = 'MAR' then 'Quotation'
              When Param2 = 'FA' then 'Finance'
              When Param2 = 'RQ' then 'Request'
              --When Param2 = 'POLH' then 'Policy Health'
              --When Param2 = 'CLMH' then 'Claim Health'
              --When Param2 = 'GLH' then 'Guarantee Letter'
              else '(None)' 
       End as AppName   
,      Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.userid)     --Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)      
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where @Group<>'1' 
and S.Param1='SEND' and S.Param2 in ('UND','CLM','MAR','SVC','FA','RQ','POLH','CLMH','GLH') 
and (ActionUser.ActionUserAuth_1=@P_USERID or ActionUser.ActionUserAuth_2=@P_USERID or ActionUser.ActionUserAuth_3=@P_USERID or ActionUser.ActionUserAuth_4=@P_USERID or ActionUser.ActionUserAuth_5=@P_USERID or ActionUser.ActionUserAuth_6=@P_USERID or ActionUser.ActionUserAuth_7=@P_USERID or ActionUser.ActionUserAuth_8=@P_USERID or ActionUser.ActionUserAuth_9=@P_USERID or ActionUser.ActionUserAuth_10=@P_USERID) and S.Status=''
)         
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_Pending_OTHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION WF_Pending_OTHER
end
GO
Create FUNCTION WF_Pending_OTHER(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))                
RETURNS TABLE                
AS RETURN (                
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
 coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,               
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		--When Param2 = 'POLH' then 'Policy Health'
		--When Param2 = 'CLMH' then 'Claim Health'
		--When Param2 = 'GLH' then 'Guarantee Letter'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)       
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where S.Param1='SEND' and S.Param2 in ('MAR','UND','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='' and SU.ID=@P_USERID and  (s.Param3<>0 or s.Param4 <> 0) and (S.ActionCode='' or S.ActionCode is null)          
)             

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'WF_OTHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION WF_OTHER
end
GO
CREATE FUNCTION WF_OTHER(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(1))          
RETURNS TABLE          
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
 coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo, 
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate
,	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		--When Param2 = 'POLH' then 'Policy Health'
		--When Param2 = 'CLMH' then 'Claim Health'
		--When Param2 = 'GLH' then 'Guarantee Letter'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
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
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)   
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where S.Param1='SEND' and S.Status='' and SU.ID = @P_USERID  
and S.param2 <> ''
and (S.ActionCode is NULL or S.ActionCode = '')       
and '1' = @Group      
)  


go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QWF_DETAIL_PICKUP_TASK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN

DROP PROCEDURE [dbo].[QWF_DETAIL_PICKUP_TASK]
end
GO

CREATE PROCEDURE [dbo].[QWF_DETAIL_PICKUP_TASK](@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)  
AS  
Select * from WF_PICKUPTASK(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate order by UserDate desc, UserTime desc  


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QWF_DETAIL_PENDING_TASK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN

DROP PROCEDURE [dbo].[QWF_DETAIL_PENDING_TASK]
end
GO

CREATE PROCEDURE [dbo].[QWF_DETAIL_PENDING_TASK](@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)    
AS    
SELECT * from (  
Select * from WF_PENDING(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE  and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%')  and DueDate between @SDueDate and @EDueDate
union all    
Select * from WF_Pending_OTHER(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate
) A  
order by UserDate desc, UserTime desc  


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QWF_DETAIL_OTHER_TASK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN

DROP PROCEDURE [dbo].[QWF_DETAIL_OTHER_TASK]
end
GO

CREATE PROCEDURE [dbo].[QWF_DETAIL_OTHER_TASK](@P_USERID AS VARCHAR(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS VARCHAR(255), @SDueDate as Date, @EDueDate as Date)    
AS    
Select * from WF_OTHER(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate  order by UserDate desc, UserTime desc   

GO


insert into PatchVersioning
select '36.02 Update Script - WF TASK (Only CGISS)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='36.01 Update Script - Update Patch 2017 (Execute Before Kom 2.27)'
Select @CurrSCript='36.02 Update Script - WF TASK (Only CGISS)'


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

