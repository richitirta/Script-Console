----/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
----BEGIN TRANSACTION
----SET QUOTED_IDENTIFIER ON
----SET ARITHABORT ON
----SET NUMERIC_ROUNDABORT OFF
----SET CONCAT_NULL_YIELDS_NULL ON
----SET ANSI_NULLS ON
----SET ANSI_PADDING ON
----SET ANSI_WARNINGS ON
----COMMIT
----BEGIN TRANSACTION
----GO
----ALTER TABLE dbo.APDRuleD ADD
----	DataFacultativeF bit NULL,
----	DataExcessPriorityF bit NULL,
----	DataTreatyF bit NULL,
----	DataAutoFacF bit NULL
----GO
----DECLARE @v sql_variant 
----SET @v = N'Data With Facultative (1 : Yes)'
----EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataFacultativeF'
----GO
----DECLARE @v sql_variant 
----SET @v = N'Data With Excess Priority (1 : Yes)'
----EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataExcessPriorityF'
----GO
----DECLARE @v sql_variant 
----SET @v = N'Data With Treaty (1 : Yes)'
----EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataTreatyF'
----GO
----DECLARE @v sql_variant 
----SET @v = N'Data With Auto Facultative (1 : Yes)'
----EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'DataAutoFacF'
----GO
----Update APDRuleD Set DataFacultativeF=0, DataTreatyF=0, DataAutoFacF=0, DataExcessPriorityF=0 Where DataExcessPriorityF is null
----COMMIT
----GO
----/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
----BEGIN TRANSACTION
----SET QUOTED_IDENTIFIER ON
----SET ARITHABORT ON
----SET NUMERIC_ROUNDABORT OFF
----SET CONCAT_NULL_YIELDS_NULL ON
----SET ANSI_NULLS ON
----SET ANSI_PADDING ON
----SET ANSI_WARNINGS ON
----COMMIT
----BEGIN TRANSACTION
----GO
----ALTER TABLE dbo.APDBucket ADD
----	ID varchar(MAX) NULL
----GO
----DECLARE @v sql_variant 
----SET @v = N'Optional Profile ID'
----EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'ID'
----GO
----COMMIT
----GO
DROP function Get_Claim_APRule
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.NeedeStampDutyF, AD.PrintLogoF, R.ID, R.DocNo
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
		and (A.TOC=AH.TOC or AH.TOC='<All>')
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
			AD.DataFacultativeF=1 and ((CArrHeader.EFAmount<>0 and Claim.CStatus='P') or (CArrHeader.FAmount<>0 and Claim.CStatus='A')) 
			)
		)
		and RArrDet.ANO=Claim.ANO and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and RArrDet.Status='A'
	) Reinsurance
	Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
	and ((AD.DataFacultativeF=0 and AD.DataAutoFacF=0 and AD.DataExcessPriorityF=0 and AD.DataTreatyF=0) or coalesce(Reinsurance.DocNo,'')<>'')
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)

)   


go



insert into PatchVersioning
select '1072 Update Script - 1 March 2024 (1) - REV',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1072 Update Script - 1 March 2024 (1) - REV'


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
