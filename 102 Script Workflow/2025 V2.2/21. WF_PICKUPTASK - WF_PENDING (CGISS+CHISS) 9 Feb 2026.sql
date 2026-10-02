Drop FUNCTION WF_PICKUPTASK
Go

CREATE FUNCTION WF_PICKUPTASK(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(50), @SDueDate smalldatetime, @EDueDate smalldatetime)    
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
    When Param2 = 'POLH' then P.PolicyNo
    When Param2 = 'CLMH' then CH.ClaimNo
    When Param2 = 'GLH' then GL.GuaranteeNo
    When Param2 = 'PRF' then PR.ID
	--When Param2 = 'PRPSL' then coalesce(H.proposalNo, '')
	--When Param2 = 'PO' then coalesce(PO.DOCNO, '')
	--When Param2 = 'PRH' then coalesce(PRH.DOCNO, '')
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
              when Param2 = 'PRF' then PR.Branch
			  --when Param2 = 'PRPSL' then H.Branch
			  --when Param2 = 'PO' then PO.Branch
			  -- when Param2 = 'PRH' then PRH.Branch
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
              When Param2 = 'PRF' then 'Profile'
			  --When Param2 = 'PRPSL' then 'Proposal'
			  --When Param2 = 'PO' then 'Purchase Order'
			  -- When Param2 = 'PRH' then 'Realization Proposal'
              else '(None)' 
       End as AppName       
,      Case 
     When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')' 
     When Param2 = 'UND-MW' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')' 
     When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'    
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')' + ' (' + Left(SV.Insured, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'FA' then coalesce(V.Voucher + ' (' + Left(V.Remarks, 50) + ')', Vm.Voucher + ' (' + Left(Vm.Remarks, 50) + ')')
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'
              When Param2 = 'PRF' then PR.ID + ' (' + Left(PR.Name, 50) + ')'  
			  --When Param2 = 'PRPSL' then H.ProposalNo + ' (' + Left(H.Remarks, 50) + ')'  
			  --When Param2 = 'PO' then PO.DocNo + ' (' + Left(PO.Remarks, 50) + ')'  
			  --  When Param2 = 'PRH' then PRH.DocNo + ' (' + Left(PRH.Remarks, 50) + ')'  
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
	 			 When Param2 = 'PRF' then 
      Case 
     When PR.VerifiedF=0 Then 'Request' 
     When PR.VerifiedF=1 Then 'Verified'
     Else '' End
	 --When Param2 = 'PRPSL' then 
  --    Case 
  --   When H.PStatus='A' Then 'Approved' 
	 --When H.PStatus='P' Then 'Processed' 
  --   When H.PStatus='R' Then 'Request' 
  --   When H.PStatus='V' Then 'Verified'
  --   When H.PStatus='C' Then 'Cancelled' 
  --   Else '' End    
	 --When Param2 = 'PO' then 
  --    Case 
  --   When po.Status='P' Then 'Approved' 
  --   When po.Status='R' Then 'Request' 
  --   When po.Status='V' Then 'Verified'
	 --Else '' End
	  --When Param2 = 'PRH' then 
   --   Case 
   --  When PRH.Status='P' Then 'Approved' 
   --  When PRH.Status='R' Then 'Request' 
   --  When PRH.Status='V' Then 'Verified'
   --  Else '' End    
              When Param2 = 'POLH' then P.PolicyNo
              When Param2 = 'CLMH' then CH.ClaimNo
              When Param2 = 'GLH' then GL.GuaranteeNo
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
Left Join Profile PR on (PR.ID=S.Param6 and S.Param2='PRF')  
--CHISS
Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')  
Left Join Profile P1 on (P1.ID = P.PayorID)    
Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')  
Left Join Profile P2 on (P2.ID = CH.ID)   
Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')  
Left Join Policy P3 on (P3.PNO=GL.PNO)    
Left Join Profile P4 on (P4.ID=P3.PayorID)    
--EMS
--Left Join EMS_PROPOSALH H on (H.PNO=S.Param3 and S.Param2='PRPSL')  
--Left Join EMS_POH PO on (PO.PONO=S.Param3 and S.Param2='PO')  
--Left Join EMS_PRH PRH on (PRH.PRNO=S.Param3 and S.Param2='PRH')
)  
GO


Drop FUNCTION WF_PENDING
GO

CREATE FUNCTION WF_PENDING(@P_USERID AS VARCHAR(50), @Group AS VARCHAR(50), @SDueDate smalldatetime, @EDueDate smalldatetime)  
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
              When Param2 = 'POLH' then P.PolicyNo
              When Param2 = 'CLMH' then CH.ClaimNo
              When Param2 = 'GLH' then GL.GuaranteeNo
              When Param2 = 'PRF' then PR.ID
			--  When Param2 = 'PRPSL' then coalesce(H.proposalNo, '')
			--When Param2 = 'PO' then coalesce(PO.DOCNO, '')
			--When Param2 = 'PRH' then coalesce(PRH.DOCNO, '')
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
  			  when Param2 = 'PRF' then PR.Branch
			  --when Param2 = 'PRPSL' then H.Branch
			  --when Param2 = 'PO' then PO.Branch
			  -- when Param2 = 'PRH' then PRH.Branch
       else   ''
       end as BRANCH
	, Case 
	  When S.Param2 = 'UND' then 'Policy Processing'
	  When S.Param2 = 'IT' then 'Inward Treaty'
	  When S.Param2 = 'CLM' then 'Claim'
	  When S.Param2 = 'SVC' then 'Servicing'
	  When S.Param2 = 'MAR' then 'Quotation'
	  When S.Param2 = 'FA' then 'Finance'
	  When S.Param2 = 'RQ' then 'Request'
	  When S.Param2 = 'PRF' then 'Profile'
	  When S.Param2 = 'PRPSL' then 'Proposal'
	   When S.Param2 = 'PO' then 'Purchase Order'
	    When S.Param2 = 'PRH' then 'Realization Proposal'
  else '(None)' 
 End as AppName 
,      Case 
    When Param2 = 'UND' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'    
     When Param2 = 'IT' then Case When A.PolicyNo='' Then A.RegNO Else A.PolicyNo+case When A.CERTIFICATENO<>'' then '-'+A.CertificateNo Else '' end End + ' (' + Left(A.AName, 50) + ')'    
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')' + ' (' + Left(SV.Insured, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
     When Param2 = 'FA' then coalesce(V.Voucher + ' (' + Left(V.Remarks, 50) + ')', Vm.Voucher + ' (' + Left(Vm.Remarks, 50) + ')')
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'
  			  When Param2 = 'PRF' then PR.ID + ' (' + Left(PR.Name, 50) + ')'    
			  --When Param2 = 'PRPSL' then H.ProposalNo + ' (' + Left(H.Remarks, 50) + ')'  
			  --When Param2 = 'PO' then PO.DocNo + ' (' + Left(PO.Remarks, 50) + ')'  
			  --When Param2 = 'PRH' then PRH.DocNo + ' (' + Left(PRH.Remarks, 50) + ')'  
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
			 When Param2 = 'PRF' then 
      Case 
     When PR.VerifiedF=0 Then 'Request' 
     When PR.VerifiedF=1 Then 'Verified'
     Else '' End    
	 -- When Param2 = 'PRPSL' then 
  --    Case 
  --   When H.PStatus='A' Then 'Approved' 
	 --When H.PStatus='P' Then 'Processed' 
  --   When H.PStatus='R' Then 'Request' 
  --   When H.PStatus='V' Then 'Verified'
  --   When H.PStatus='C' Then 'Cancelled' 
  --   Else '' End    
	 --When Param2 = 'PO' then 
  --    Case 
  --   When po.Status='P' Then 'Approved' 
  --   When po.Status='R' Then 'Request' 
  --   When po.Status='V' Then 'Verified'
	 --Else '' End
	 -- When Param2 = 'PRH' then 
  --    Case 
  --   When PRH.Status='P' Then 'Approved' 
  --   When PRH.Status='R' Then 'Request' 
  --   When PRH.Status='V' Then 'Verified'
  --   Else '' End    
              When Param2 = 'POLH' then P.PolicyNo
              When Param2 = 'CLMH' then CH.ClaimNo
              When Param2 = 'GLH' then GL.GuaranteeNo
              else '' 
       End as Status_Transasction   
from get_SysRequest(@P_USERID, @Group,@SDueDate, @EDueDate) S
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
Left Join Profile PR on (PR.ID=S.Param6 and S.Param2='PRF')
--CHISS
Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')  
Left Join Profile P1 on (P1.ID = P.PayorID)    
Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')  
Left Join Profile P2 on (P2.ID = CH.ID)   
Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')  
Left Join Policy P3 on (P3.PNO=GL.PNO)    
Left Join Profile P4 on (P4.ID=P3.PayorID)      
--EMS
--Left Join EMS_PROPOSALH H on (H.PNO=S.Param3 and S.Param2='PRPSL')  
--Left Join EMS_POH PO on (PO.PONO=S.Param3 and S.Param2='PO')  
--Left Join EMS_PRH PRH on (PRH.PRNO=S.Param3 and S.Param2='PRH')
)         
GO

Drop FUNCTION get_SysRequest
GO

Create function get_SysRequest(@P_USERID AS VARCHAR(50), @Group varchar(50), @SDueDate smalldatetime, @EDueDate smalldatetime)     
RETURNS @TempSysRequest TABLE (ID int,Remarks varchar(Max), UserDate	datetime, UserTime varchar(8), USERID varchar(50), Status varchar(1), Param2 varchar(50),Param3	int, Param4	int, Param5	varchar(50),Param6	varchar(50), ActionCode	varchar(10), DueDate	datetime, Name	varchar(100), BranchID	varchar(10))

AS
BEGIN
	if @Group='My Subordinate Task'  OR @Group='MY SUBORDINATE TASK' OR @Group='1'
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name, SU.Branch
		from SysRequest S
		Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and ActionUser.ActionUser=S.Param5) 
		Left Join ActionList AL on (AL.ActionCode=S.ActionCode) 
		Inner Join SysUser SU on (SU.ID=@P_UserID and (S.Param5=SU.ID or S.Param5=SU.Type or ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH','PRF','PRPSL','PO','PRH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	else if @Group='My Task' OR @Group='MY TASK' OR @Group='2' 
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name , SU.Branch
		from SysRequest S
		Inner Join SysUser SU  on (SU.ID=@P_UserID and (S.Param5=SU.ID or S.Param5 = SU.Type))				
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH','PRF','PRPSL','PO','PRH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	else if @Group='Group Task' OR @Group='GROUP TASK' OR @Group='3' 
	Begin
		insert into @TempSysRequest
		Select distinct Top 100  S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name, SU.Branch
		from SysRequest S
		Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode 
		and ActionUser.ActionUser=S.Param5) 
		Left Join ActionList AL on (AL.ActionCode=S.ActionCode) 
		Inner Join SysUser SU on (SU.ID=@P_UserID)
		Inner Join SysUserGroup S5 on (S5.[Group]=S.Param5)
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH','PRF','PRPSL','PO','PRH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		and (S.Param5=SU.ID or S.Param5=S5.[Group] or ActionUser.ActionUserAuth_1=S5.[Group] or ActionUser.ActionUserAuth_2=S5.[Group] or ActionUser.ActionUserAuth_3=S5.[Group] or ActionUser.ActionUserAuth_4=S5.[Group] or ActionUser.ActionUserAuth_5=S5.[Group] or ActionUser.ActionUserAuth_6=S5.[Group] or ActionUser.ActionUserAuth_7=S5.[Group] or ActionUser.ActionUserAuth_8=S5.[Group] or ActionUser.ActionUserAuth_9=S5.[Group] or ActionUser.ActionUserAuth_10=S5.[Group])
		Order By S.ID desc
	End
	else
	Begin
		insert into @TempSysRequest
		Select Top 100 S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SUSentBy.Name , SUSentBy.Branch 
		from SysRequest S
		Inner Join SysUser SUSentBy on (SUSentBy.ID=@P_UserID and S.UserID=SUSentBy.ID )
		Where S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH','PRF','PRPSL','PO','PRH') and S.Status=''
		and S.DueDate Between @SDueDate and @EDueDate
		Order By S.ID desc
	End
	RETURN
END

GO