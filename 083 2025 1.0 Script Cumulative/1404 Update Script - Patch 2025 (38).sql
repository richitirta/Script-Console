SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION Get_Policy_APRule END
GO

Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.Class, AD.Version, AD.PrintLogoF, 
max(AD.RuleID) as RuleID, 
max(AD.RepName) as RepName, 
max(AD.ExeName) as ExeName, 
cast(max(cast(AH.AutoInforceF as Int)) as bit) AutoInforceF, 
cast(max(cast(R.ApplyeStampDutyF as Int)) as bit) ApplyeStampDutyF, 
cast(max(cast(AD.NeedEmailF as Int)) as bit) NeedEmailF, 
cast(max(cast(AD.NeedPrintF as Int)) as bit) NeedPrintF, 
cast(max(cast(AD.NeedeStampDutyF as Int)) as bit) NeedeStampDutyF, 
max(AD.EmailTo) as EmailTo
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
		and (
			(AH.ApplySegmentF=0 and (C.Segment=AH.Segment or AH.Segment='<All>')) or
			(AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=C.Segment))
		)
		and (
			(AH.ApplyPHolderF=0) or
			(AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))
		)
		and (
			(AH.ApplyInsuredF=0) or
			(AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))
		)
	)  A
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)
Group By AD.Class, AD.Version, AD.PrintLogoF
)       




GO
insert into PatchVersioning
select '1404 Update Script - Patch 2025 (38)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1404 Update Script - Patch 2025 (38)'


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