--9 Mar 2018
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefCCYDate' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
ALTER TABLE pVoucher ADD
	RefCCYDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Reference Currency Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'RefCCYDate'
END
GO


--12 Mar 2018
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RiskF' AND Object_ID = Object_ID(N'RECLASS'))
BEGIN
ALTER TABLE RECLASS ADD
	RiskF bit NULL
DECLARE @v sql_variant 
SET @v = N'Claim Risk Only (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RECLASS', N'COLUMN', N'RiskF'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Claim_Cession') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE Claim_Cession
end
GO
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                    
AS                    
SELECT coalesce(RePolicy.ID,''), (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category, Reinsurance.Share,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Limit,                    
Case When coalesce(Event.Category,'')='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Excess,                    
Reinsurance.ExcessType,                
RECLASS.CessionF , RECLASS.AssessmentF, 
REINSURANCE.Deductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Deductible, 
REINSURANCE.A_Deductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_Deductible, 
REINSURANCE.A_EDeductible*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_EDeductible, 
REINSURANCE.Aggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Aggregate, 
REINSURANCE.A_Aggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_Aggregate, 
REINSURANCE.A_EAggregate*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as A_EAggregate
FROM Claim          
Left Join Event On (Event.EventNo=Claim.EventNo)          
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)          
Inner Join Cover on (Cover.CNO=Acceptance.CNO)          
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)          
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)          
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)          
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)          
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=Reinsurance.RYEAR and ReRate.Currency=Reinsurance.Currency)
Inner Join SysTab on (1=1)
WHERE Claim.CNO=@PCNO           
and RArrHeader.EXOLF=0        --Not Exclude XOL          
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0)     
and (coalesce(Event.Category,'')<>'E' or ReClass.RiskF=0)     
and (coalesce(Event.Category,'')='E' or Reinsurance.Category<>'E')           
And Reinsurance.Category<>'S' --Not Shortfall Surplus          
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)        
And  
(        
 (      
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)       
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))       
 or ReClass.MinPeriod=0)                                 
 And (      
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)       
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))       
 or ReClass.MaxPeriod=0)  
)        
-- If Risk is Excluded          
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)          
And (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or Reinsurance.Currency=SysTab.Currency)
Order By coalesce(RePolicy.ID,'') Desc, 
Case When (coalesce(Event.Category,'R')<>'R' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, 
(Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc             


  
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TaxPayment_OC' AND Object_ID = Object_ID(N'nSL'))
BEGIN
ALTER TABLE nSL ADD
	TaxPayment_OC float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Tax Payment Original Currency'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'nSL', N'COLUMN', N'TaxPayment_OC'
END
GO

--20 Mar 2018
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefCCYDate' AND Object_ID = Object_ID(N'nVoucher'))
BEGIN
ALTER TABLE nVoucher ADD
	RefCCYDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Reference Currency Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'nVoucher', N'COLUMN', N'RefCCYDate'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UseExchRateOnLossDate' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab ADD
	UseExchRateOnLossDate bit NULL
DECLARE @v sql_variant 
SET @v = N'Use Exchange Rate ON Loss Date (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'UseExchRateOnLossDate'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectClaimed') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCheckObjectClaimed
end
Go
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='', @P_RefNo varchar(20)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.OCNO, Max(C1.CNO) as CNO   
 from Claim C1  Left Join CLLOSS C2 on (C2.CNO=C1.CNO) 
 Where C1.ClaimNo<>@P_ClaimNo and C1.ClaimNo<>@P_RefNO and C1.RefNo<>@P_RefNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo and C1.LossDate between dateadd(day,-14,@P_LossDate) and dateadd(day,14,@P_LossDate)   
 and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
 and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
 and (@P_COL='' or C1.COL=@P_COL)   
 and (@P_Location='' or C1.location=@P_Location)   
 Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
   
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_7') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLACC_7
end
Go
CREATE Procedure QCLACC_7(@P_CNO as int)
as   
Select C1.ClaimNo, C1.LossDate 
from Claim C2
Inner Join Claim C1 on (C2.ClaimNo<>C1.ClaimNo and (C1.ClaimNo=C2.RefNo or C1.RefNo=C2.RefNo) and C2.PolicyNo=C1.PolicyNo and C2.CertificateNo=C1.CertificateNo and C2.LossDate=C1.LossDate)
Left Join CLLOSS C3 on (C3.CNO=C1.CNO)
Left Join CLLOSS C4 on (C4.CNO=C2.CNO)
Where C2.CNO=@P_CNO and coalesce(C3.TOI,'')=coalesce(C4.TOI,'')
and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')

go

--21 Mar 2018

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('SysUserVType'))
BEGIN
CREATE TABLE SysUserVType(
	ID varchar(50) NOT NULL,
	VType varchar(10) NOT NULL
) ON [PRIMARY]
ALTER TABLE SysUserVType  WITH NOCHECK ADD  CONSTRAINT FK_SysUserVType_SysUser FOREIGN KEY(ID)
REFERENCES dbo.SysUser (ID)
ALTER TABLE SysUserVType CHECK CONSTRAINT FK_SysUserVType_SysUser
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User ID (see SysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserVType', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VType ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserVType', @level2type=N'COLUMN',@level2name=N'VType'
END
GO


IF NOT EXISTS(SELECT * FROM sysForm WHERE Fname='ALLOWPASSUSERVTYPE')
BEGIN
Insert into sysForm(Fname, Description, FCode) Select 'ALLOWPASSUSERVTYPE','Allow ByPass User VType Map','ACTIVITIES'
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserVType') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION FN_UserVType
GO
CREATE FUNCTION FN_UserVType (@P_UserID as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT VType.*       
 from VType       
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' 
 or dbo.getPrivileges(@P_UserID,'ALLOWPASSUSERVTYPE')<>0
 or EXISTS (Select SysUserVType.VType from SysUserVType Where SysUserVType.VType=VType.VType and SysUserVType.ID=@P_UserID and SysUserVType.VType=VType.VType)
 )   
)          
 
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RateAdjF' AND Object_ID = Object_ID(N'ReClassDet'))
BEGIN
ALTER TABLE ReClassDet ADD RateAdjF bit NULL
DECLARE @v sql_variant 
SET @v = N'Calculate for Rate Adjustment (0 : No, 1 ; Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ReClassDet', N'COLUMN', N'RateAdjF'
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCODE' AND Object_ID = Object_ID(N'SYSUSER'))
BEGIN
ALTER TABLE SYSUSER ADD CCODE VARCHAR(10)
END
GO

--VERSIONING
insert into versioning
select '2018 V.1.5.0',GETDATE(),'2018 V.1.5.0',GETDATE(),'K: 2018 V.1.5.0',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='44 Script Komulatif Konsol 2018 1.4'
Select @CurrSCript='45 Script Komulatif Konsol 2018 1.5'


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
