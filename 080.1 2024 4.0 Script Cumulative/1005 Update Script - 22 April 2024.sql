IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExTOC' AND Object_ID = Object_ID(N'APDRuleH'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.APDRuleH ADD
	ExTOC varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Exclusion Sub Class Business (see TOC)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleH', N'COLUMN', N'ExTOC'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EMailTo' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.APDRuleD ADD
	EMailTo varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Email to Option (''DEFAULT'', ''EMAIL_2'',''EMAIL_3'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'EMailTo'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EMailTo' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.APDBucket ADD
	EMailTo varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Email To Option (''DEFAULT'', ''EMAIL_2'',''EMAIL_3'')'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'EMailTo'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Email_3' AND Object_ID = Object_ID(N'Profile'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.Profile ADD
	Email_3 varchar(512) NULL
	
DECLARE @v sql_variant 
SET @v = cast(N'Electronic Mail' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'Email_3'
end
GO

DROP function Get_Policy_APRule
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.NeedeStampDutyF, AD.PrintLogoF, AD.EmailTo
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, A.ApplyeStampDutyF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	CROSS APPLY
		(  
		Select TOP 1 TOC.ApplyeStampDutyF
		from Acceptance A
		Inner Join TOC on (TOC.TOC=A.TOC)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join Profile P on (P.ID=C.PHolder)
		Where A.ANO=@P_ANO 
		and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')
		and (C.ISType=AH.ISType or AH.ISType='<All>')
		and (C.Segment=AH.Segment or AH.Segment='<All>') 
		and (TOC.TOC=AH.TOC or TOC.COB=AH.TOC or AH.TOC='<All>')
		and Not (TOC.TOC=AH.ExTOC or TOC.COB=AH.ExTOC)
		and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
		and charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0  
		and (
		  -- Mapping Data with SysClass
		  (AD.Class='CD' and exists (Select Top 1 A1.Type from AccAss A1 Where A1.ANO=A.ANO and A1.Type in ('BB','BA','BO','BC','BP','BD')))
		  or
		  (AD.Class<>'CD')
		)
	)  A
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)
)       

GO


Drop function Get_Claim_APRule
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, AD.PrintLogoF, AD.EmailTo, R.ID, R.DocNo
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, A.ApplyeStampDutyF, Reinsurance.ID, Reinsurance.DocNo
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	CROSS APPLY 	(  
		Select TOP 1 TOC.ApplyeStampDutyF
		from Claim
		Inner Join Acceptance A on (A.ANO=Claim.ANO)
		Inner Join TOC on (TOC.TOC=A.TOC)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join Profile P on (P.ID=C.PHolder)		
		Where Claim.CNO=@P_CNO 
		and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')
		and (C.ISType=AH.ISType or AH.ISType='<All>')
		and (C.Segment=AH.Segment or AH.Segment='<All>') 
		and (TOC.TOC=AH.TOC or TOC.COB=AH.TOC or AH.TOC='<All>')
		and Not (TOC.TOC=AH.ExTOC or TOC.COB=AH.ExTOC)
		and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
		and charindex(Claim.CType,AD.ClaimCType)<>0 and charindex(Claim.CStatus,AD.ClaimCStatus)<>0  	
	)  A

	Outer Apply (
		Select RPart.ID, CASE WHEN COALESCE(RPart.DOCNO,'')='' THEN RPart.DOCNO ELSE Reinsurance.DOCNO END AS DOCNO
		from Claim, RArrHeader, CArrHeader, Reinsurance, RPart
		Where Claim.CNO=@P_CNO and CArrheader.CNO=Claim.CNO and RArrHeader.ANO=Claim.ANO
		and (
			(
			Case When AD.DataExcessPriorityF=1 and ((CArrHeader.EXPAmount<>0 and Claim.CStatus='P') or (CArrHeader.XPAmount<>0 and Claim.CStatus='A')) then RArrHeader.XPID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataTreatyF=1 and ((CArrHeader.EQAmount<>0 and Claim.CStatus='P') or (CArrHeader.QAmount<>0 and Claim.CStatus='A')) then RArrHeader.QID Else '' end = Reinsurance.RID
			)
			or
			(
			Case When AD.DataAutoFacF=1 and ((CArrHeader.EAAmount<>0 and Claim.CStatus='P') or (CArrHeader.AAmount<>0 and Claim.CStatus='A')) then RArrHeader.AID Else '' end = Reinsurance.RID
			)
		)
		and RPart.RNO=Reinsurance.RNO

		Union All

		Select FPart.ID, FPart.SlipNO AS DOCNO
		from Claim, CArrHeader, RArrDet, FPart
		Where Claim.CNO=@P_CNO and CArrheader.CNO=Claim.CNO 
		and (
			(
			AD.DataFacultativeF=1 and ((CArrHeader.EFAAmount<>0 and Claim.CStatus='P') or (CArrHeader.FAmount<>0 and Claim.CStatus='A')) 
			)
		)
		and RArrDet.ANO=Claim.ANO and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.Status='A'
	) Reinsurance
	Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
	and ((AD.DataFacultativeF=0 and AD.DataAutoFacF=0 and AD.DataExcessPriorityF=0 and AD.DataTreatyF=0) or coalesce(Reinsurance.DocNo,'')<>'')
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)

)   

GO




insert into PatchVersioning
select '1005 Update Script - 22 April 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1005 Update Script - 22 April 2024'


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

